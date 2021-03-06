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

admin.site.register(Question)
admin.site.register(Option)
admin.site.register(QuestionChain)
admin.site.register(QuestionProject)

# admin.site.register(JSONFiles)
# admin.site.register(ChainToQuestion)
# admin.site.register(QuestionProjectToChain)