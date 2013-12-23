from trx_app import models
from trx_app.serializers import *
#from datetime import date, datetime, time

# get some basic info about the patient
def get_patient(patient, status):

    status["success"] = False

    # TODO: do something about the password (encrypted) being passed back using the dynamic pop stuff
    # try:
    patient = models.Patient.objects.filter(lastName=patient.lastName)
        #firstName=patient.firstName)
        # , middleName=patient.middleName, lastName=patient.lastName, birthday=birthday, isCurrent=True)        
    status["data"]["patient"] = patient
    status["success"] = True
    # except Exception as e:
    #     status["exception"] += str(e)

    return status



