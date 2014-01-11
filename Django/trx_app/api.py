from django.views.decorators.csrf import csrf_exempt
# from django.contrib.auth import authenticate
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.decorators import api_view
from trx_app import controller
from trx_app.serializers import *

# TODO: do something about my permission schemes
# TODO: add sync config api call. returns approp question file, doctors, surgery types, etc (based on trip/language)
# TODO: figure out why serializers ignore the id field when deserializing (difference between insert and update, but it is stupid)

# SATTODO: commit, delete obselete folders/files
# SATTODO: api method to return config file (pull from jsonfiles) based on file_name
# SATTODO: api method to return list of isLive jsonfiles
# SATTODO: configure server
# SATTODO: history api methods get/set

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

# GET methods

@csrf_exempt
@api_view(['POST'])
def get_patient(request):
    
    """
    Gets the current patient record for a specified patient by id or by unique identifier combo.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "patient" in request.DATA:
                        
            if "id" in request.DATA["patient"] and request.DATA["patient"]["id"] != 0:
                retval = controller.get_patient(retval, None, request.DATA["patient"]["id"]) 
                retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"])).data
            else:
                patient = PatientSerializer(data=request.DATA["patient"], fields=('firstName', 'lastName', 'birthday'))
                patient_valid = patient.is_valid()
            
                if patient_valid:
                    retval = controller.get_patient(retval, patient.object, None) 
                    retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"])).data
                else:
                    retval["error"] = patient.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_audio_list(request):
    # TODO: need to return actual audio file and not just audio name?
    
    """
    Gets any audio recordings for a specified patient record by patient record id.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "patient" in request.DATA and "id" in request.DATA["patient"]:
            
            retval = controller.get_audio_list(retval, request.DATA["patient"]["id"]) 
            retval["data"]["audio"] = (AudioSerializer(retval["data"]["audio"], many=True)).data
            
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_image_list(request):
    # TODO: need to return actual image file and not just name?
    
    """
    Gets any images for a specified patient record by patient record id.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "patient" in request.DATA and "id" in request.DATA["patient"]:
            
            retval = controller.get_image_list(retval, request.DATA["patient"]["id"]) 
            retval["data"]["image"] = (ImageSerializer(retval["data"]["image"], many=True)).data
            
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_order(request):
    
    """
    Gets an order for a specified patient by id and order type.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "order" in request.DATA:
             
            if "id" in request.DATA["order"] and request.DATA["order"]["id"] != 0:
                retval = controller.get_order(retval, None, request.DATA["order"]["id"]) 
                retval["data"]["order"] = (OrderSerializer(retval["data"]["order"])).data
            else:
                order = OrderSerializer(data=request.DATA["order"], fields=('orderType', 'patient'))
                order_valid = order.is_valid()
            
                if order_valid:
                    retval = controller.get_order(retval, order.object, None) 
                    retval["data"]["order"] = (OrderSerializer(retval["data"]["order"])).data
                else:
                    retval["error"] = order.errors

        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

# SAVE methods

@csrf_exempt
@api_view(['POST'])
def save_patient(request):
    
    """
    Insert or update a patient record, along with any data related to a specific patient.
    Ignores any patient id's passed in for non-patient objects.
    To check for success, test every id returned.
    """
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    # TODO: must save more than just the patient record
    try:
        if request.method == 'POST' and "patient" in request.DATA:
            patient = PatientSerializer(data=request.DATA["patient"])
            patient_valid = patient.is_valid()
            if patient_valid:
                if "id" in request.DATA["patient"]:
                    patient.object.id = request.DATA["patient"]["id"]

                retval = controller.save_patient(retval, patient.object)
                retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"])).data
                patient_id = retval["data"]["patient"]["id"]

                # save any orders passed in
                if patient_id and "order" in request.DATA:
                    request.DATA["order"]["patient"] = patient_id
                    order = OrderSerializer(data=request.DATA["order"])
                    order_valid = order.is_valid()
                    if order_valid:
                        if "id" in request.DATA["order"]:
                            order.object.id = request.DATA["order"]["id"]

                        retval = controller.save_order(retval, order.object)
                        retval["data"]["order"] = (OrderSerializer(retval["data"]["order"])).data
                    else:
                        retval["error"] = order.errors
            else:
                retval["error"] = patient.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def save_audio(request):
    
    """
    Insert or update an audio recording for a patient record.
    """
    # curl -F "record=@IMG_4303.jpg" -F "audio={\"name\":\"Help\", \"patient\":2};type=application/json" http://127.0.0.1:8000/trx_app/save_audio/
    # need help testing, for now if you do BAD WAY (following)
    # curl -F "record=@IMG_4303.jpg" -F "name=Help" -F "patient=2" http://127.0.0.1:8000/trx_app/save_audio/

    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and request.FILES and request.DATA:
            audio_data = request.FILES['record']

            # TODO: bad way
            # audio = AudioSerializer(data=request.DATA, fields=('name', 'patient'))

            # TODO: good way
            audio = AudioSerializer(data=request.DATA["audio"], fields=('name', 'patient'))

            audio_valid = audio.is_valid()
            if audio_valid:

                if "id" in request.DATA["audio"]:
                    audio.object.id = request.DATA["audio"]["id"]

                retval = controller.save_audio(retval, audio.object, audio_data)
                retval["data"]["audio"] = (AudioSerializer(retval["data"]["audio"])).data
            else:
                retval["error"] = audio.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def save_image(request):
    
    """
    Insert or update an image for a patient record.
    """
    # taken straight from save_audio:
        # curl -F "record=@IMG_4303.jpg" -F "audio={\"name\":\"Help\", \"patient\":2};type=application/json" http://127.0.0.1:8000/trx_app/save_audio/
        # need help testing, for now if you do BAD WAY (following)
        # curl -F "record=@IMG_4303.jpg" -F "name=Help" -F "patient=2" http://127.0.0.1:8000/trx_app/save_audio/
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and request.FILES and request.DATA:
            image_data = request.FILES['image']

            # TODO: bad way
            # image = ImageSerializer(data=request.DATA, fields=('name', 'patient', 'isProfile'))

            # TODO: better way
            image = ImageSerializer(data=request.DATA["image"], fields=('name', 'patient', 'isProfile'))

            image_valid = image.is_valid()
            if image_valid:

                if "id" in request.DATA["image"]:
                    image.object.id = request.DATA["image"]["id"]

                retval = controller.save_image(retval, image.object, image_data)
                retval["data"]["image"] = (ImageSerializer(retval["data"]["image"])).data
            else:
                retval["error"] = image.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def save_order(request):
    
    """
    Insert or update a patient's orders.
    """
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "order" in request.DATA:
            order = OrderSerializer(data=request.DATA["order"])
            order_valid = order.is_valid()
            if order_valid:
                if "id" in request.DATA["order"]:
                    order.object.id = request.DATA["order"]["id"]

                retval = controller.save_order(retval, order.object)
                retval["data"]["order"] = (OrderSerializer(retval["data"]["order"])).data
            else:
                retval["error"] = order.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

