from trx_app import models
from trx_app.serializers import *
#from datetime import date, datetime, time

def get_patient(status, patient, patient_id):
    
    """
    Get patient's basic information.
    """

    status["success"] = False
    status["data"]["patient"] = {}

    try:

        if patient_id:
            p = models.Patient.objects.filter(pk=patient_id)
        else:
            p = models.Patient.objects.filter(
                firstName=patient.firstName, 
                lastName=patient.lastName,
                birthday=patient.birthday,
                isCurrent=True)

        if len(p) == 1:
            status["data"]["patient"] = p[0]
            status["success"] = True
        elif p:
            status["error"] = "More than one record found."
        else:
            status["error"] = "No patient record found." 
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_patient_list(status):
    
    """
    Get current patients.
    """

    status["success"] = False
    status["data"]["patient"] = {}

    try:

        p = models.Patient.objects.filter(isCurrent=True)

        status["data"]["patient"] = p
        status["success"] = True
        
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_audio_list(status, patient_id):
    
    """
    Get any audio recordings for a specified patient record.
    """

    status["success"] = False
    status["data"]["audio"] = {}

    try:
        a = models.Audio.objects.filter(patient__pk=patient_id)

        if a:
            status["data"]["audio"] = a
        
        status["success"] = True
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_image_list(status, patient_id):
    
    """
    Get any images for a specified patient record.
    """

    status["success"] = False
    status["data"]["image"] = {}

    try:
        i = models.Image.objects.filter(patient__pk=patient_id)

        if i:
            status["data"]["image"] = i
        
        status["success"] = True
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_order(status, order, order_id):
    
    """
    Get a patient's orders.
    """

    status["success"] = False
    status["data"]["order"] = {}

    try:

        if order_id:
            o = models.Order.objects.filter(pk=order_id)
        else:
            o = models.Order.objects.filter(patient=order.patient, orderType=order.orderType)

        if len(o) == 1:
            status["data"]["order"] = o[0]
            status["success"] = True
        elif o:
            status["error"] = "More than one record found."
        else:
            status["error"] = "No record found." 
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_config_list(status):
    
    """
    Get list of live configuration files
    """

    status["success"] = False
    status["data"]["config"] = {}

    try:

        c = models.JSONFiles.objects.filter(isLive=True)
        status["data"]["config"] = c
        status["success"] = True
        
    except Exception as e:
        status["exception"] += str(e)

    return status

def get_config(status, config_id):
    
    """
    Get a configuration file.
    """

    status["success"] = False
    status["data"]["config"] = {}

    try:

        c = models.JSONFiles.objects.filter(pk=config_id)

        if len(c) == 1:
            status["data"]["config"] = c[0]
            status["success"] = True
        elif c:
            status["error"] = "More than one record found."
        else:
            status["error"] = "No configuration file found." 
    except Exception as e:
        status["exception"] += str(e)

    return status

def save_audio(status, audio, audio_data):
    
    """
    Insert or update an audio recording for a specified patient record.
    """

    status["success"] = False
    status["data"]["audio"] = {}

    try:

        a = models.Audio(
            name=audio.name,
            patient=audio.patient,
            record=audio_data
        )
        
        if audio.id:
            previous = models.Audio.objects.filter(pk=audio.id)
            if previous:
                previous = previous[0]
                a.pk = previous.id
                a.created = previous.created

        a.save()

        if a.pk:
            status["data"]["audio"] = a
            status["success"] = True
        else:
            status["error"] = "Audio file could not be saved."
    except Exception as e:
        status["exception"] += str(e)

    return status

def save_image(status, image, image_data):
    
    """
    Insert or update an image for a specified patient record.
    """

    status["success"] = False
    status["data"]["image"] = {}

    try:

        i = models.Image(
            name=image.name,
            patient=image.patient,
            isProfile=image.isProfile,
            record=image_data
        )
        
        if image.id:
            previous = models.Image.objects.filter(pk=image.id)
            if previous:
                previous = previous[0]
                i.pk = previous.id
                i.created = previous.created

        i.save()

        if i.pk:
            status["data"]["image"] = i
            status["success"] = True
        else:
            status["error"] = "Image file could not be saved."
    except Exception as e:
        status["exception"] += str(e)

    return status

def save_patient(status, patient):
    
    """
    Insert or update a patient record.
    """

    status["success"] = False
    status["data"]["patient"] = {}

    try:

        p = models.Patient(
            firstName=patient.firstName,
            middleName=patient.middleName,
            lastName=patient.lastName,
            birthday=patient.birthday,
            surgeryType=patient.surgeryType,
            doctor=patient.doctor,
            location=patient.location,
            hasTimeout=patient.hasTimeout,
            isCurrent=patient.isCurrent
        )
        
        if patient.id:
            previous = models.Patient.objects.filter(pk=patient.id)
            if previous:
                previous = previous[0]
                p.pk = previous.id
                p.created = previous.created

        p.save()

        if p.pk:
            status["data"]["patient"] = p
            status["success"] = True
        else:
            status["error"] = "Patient could not be saved."
    except Exception as e:
        status["exception"] += str(e)

    return status

def save_order(status, order):
    
    """
    Insert or update a patient's orders.
    """

    status["success"] = False
    status["data"]["order"] = {}

    try:

        o = models.Order(
            orderType = order.orderType,
            patient = order.patient,
            text = order.text,
            index = order.index,
            isEditable = order.isEditable
            )
        
        if order.id:
            previous = models.Order.objects.filter(pk=order.id)
            if previous:
                previous = previous[0]
                o.pk = previous.id
                o.created = previous.created

        o.save()

        if o.pk:
            status["data"]["order"] = o
            status["success"] = True
        else:
            status["error"] = "Order could not be saved."
    except Exception as e:
        status["exception"] += str(e)

    return status

