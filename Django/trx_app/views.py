from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.decorators import api_view
from trx_app import controller
from trx_app.serializers import *

# TODO: should prolly be try/catch
# TODO: do something about my permission schemes
# TODO: maybe should check results of the authenticate

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

# TODO: decrypt/encrypt password
# TODO: this used to be a get method. we probably don't actually need this method.
@csrf_exempt
@api_view(['POST'])
def get_patient(request):
    retval = {
        "success": False, 
        "data": {}, 
        "exception": "", 
        "error": ""
    }

    if request.method == 'POST':
        patient = PatientSerializer(data=request.DATA["patient"])
        patient_valid = patient.is_valid()
        if patient_valid:
            retval = controller.get_patient(patient, retval) 
            retval["data"]["patient"] = (PatientSerializer(retval["data"]["patient"])).data
        else:
            retval["error"] = patient.errors

    return JSONResponse(retval, status=200)
