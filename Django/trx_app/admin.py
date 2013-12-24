from django.contrib import admin
from trx_app.models import *

admin.site.register(AppData)
admin.site.register(Audio)
admin.site.register(Doctor)
admin.site.register(History)
admin.site.register(Image)
admin.site.register(LaboratoryData)
admin.site.register(Language)
admin.site.register(Location)
admin.site.register(Order)
admin.site.register(OrderTemplate)
admin.site.register(OrderType)
admin.site.register(Patient)
admin.site.register(PhysicalExam)
admin.site.register(Recovery)
admin.site.register(SurgeryType)
admin.site.register(Video)
admin.site.register(VideoType)

#TODO: since you can add, for example, not current doctors to a patient/pr, it would be nice to maybe have a note or something?
#	idk, don't enter bad data vis the admin is the point