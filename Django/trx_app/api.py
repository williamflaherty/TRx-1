from django.views.decorators.csrf import csrf_exempt
# from django.contrib.auth import authenticate
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.decorators import api_view
from trx_app import controller
from trx_app.serializers import *

# TODO: do something about my permission schemes
# TODO: figure out why serializers ignore the id field when deserializing (difference between insert and update, but it is stupid)
# TODO: I know there's a note somewhere about the ugly way I'm handling some gets (ex blahblah(retval, None, id))
#       either clean up the way I'm doing it by finding a better way to do it
#       figure out the serializers ignoring id problem, which should fix it
#       or use named parameters so I want to kill myself a little less
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
                retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"], fields=(
                        "id", 
                        "firstName",
                        "middleName",
                        "lastName", 
                        "birthday", 
                        "surgeryType", 
                        "doctor", 
                        "location", 
                        "hasTimeout", 
                        "isCurrent",
                        "appointment"))).data            
            else:
                patient = PatientSerializer(data=request.DATA["patient"], fields=('firstName', 'lastName', 'birthday'))
                patient_valid = patient.is_valid()
            
                if patient_valid:
                    retval = controller.get_patient(retval, patient.object, None) 
                    retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"], fields=(
                        "id", 
                        "firstName",
                        "middleName",
                        "lastName", 
                        "birthday", 
                        "surgeryType", 
                        "doctor", 
                        "location", 
                        "hasTimeout", 
                        "isCurrent",
                        "appointment"))).data
                else:
                    retval["error"] = patient.errors
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_patient_list(request):
    
    """
    Gets all current patient records.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST': 
            
            # TODO: only profile picture should be gotten? maybe as another field in dict with value of img name
            #       could be accomplished by adding field to serializer and method get_profile to model
            # for now, if there is a profile image, it is listed in image set with isProfile as True
            retval = controller.get_patient_list(retval) 
            retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"], many=True)).data
            
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

@csrf_exempt
@api_view(['POST'])
def get_config_list(request):
    
    """
    Gets the names of all live configuration files.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST':
                                
            retval = controller.get_config_list(retval) 
            retval["data"]["config"] = (ConfigSerializer(retval["data"]["config"], many=True, fields=('id', 'file_name'))).data

        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_config(request):
    
    """
    Gets a configuration file by id (it can't be by name since names are not unique).
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "config" in request.DATA and "id" in request.DATA["config"]:
                        
            retval = controller.get_config(retval, request.DATA["config"]["id"]) 
            retval["data"]["config"] = (ConfigSerializer(retval["data"]["config"])).data
            
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)

@csrf_exempt
@api_view(['POST'])
def get_history_list(request):
    
    """
    Gets the entire history for a patient by patient id.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "patient" in request.DATA and "id" in request.DATA["patient"] and request.DATA["patient"]["id"] != 0:
            retval = controller.get_history_list(retval, request.DATA["patient"]["id"]) 
            retval["data"]["history"] = (HistorySerializer(retval["data"]["history"], many=True)).data            
        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)


@csrf_exempt
@api_view(['POST'])
def get_history(request):
    
    # TODO: collapse get_history and get_history list if we do want to keep both
    #       by if only patient id specified, get whole list
    #       otherwise get specific based on p_id/h_key or h_id

    """
    Gets a specific answer based on patient id and history key OR by history id.
    """    
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    try:
        if request.method == 'POST' and "history" in request.DATA:

            if "id" in request.DATA["history"] and request.DATA["history"]["id"] != 0:        
                retval = controller.get_history(retval, None, request.DATA["history"]["id"]) 
                retval["data"]["history"] = (HistorySerializer(retval["data"]["history"])).data    
            else:
                history = HistorySerializer(data=request.DATA["history"], fields=('key', 'patient'))
                history_valid = history.is_valid()
                
                if history_valid:      
                    retval = controller.get_history(retval, history.object, None) 
                    retval["data"]["history"] = (HistorySerializer(retval["data"]["history"])).data
                else:
                    retval["error"] = history.errors
                
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

@csrf_exempt
@api_view(['POST'])
def save_history(request):
    
    """
    Insert or update one or more history answers, so pass it in as a list.
    To check for success, test every id returned.
    """
    
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    # TODO: I would like to not hit the db a bajillion times, but I'm tired
    try:
        if request.method == 'POST' and "history" in request.DATA:
            answers = []
            for answer in request.DATA["history"]:

                history = HistorySerializer(data=answer)
                history_valid = history.is_valid()
                if history_valid:
                    current = retval
                    if "id" in answer:
                        history.object.id = answer["id"]
                    
                    current = controller.save_history(current, history.object)
                    answers.append(current["data"]["history"])
                
                else:
                    # TODO: this doesn't do much good unless I associate which history object caused it
                    retval["error"] = history.errors
            
            retval["data"]["history"] = (HistorySerializer(answers, many=True)).data

        else:
            retval["error"] = "Not a valid request."
    except Exception as e:
        retval["exception"] += str(e)

    return JSONResponse(retval, status=200)
