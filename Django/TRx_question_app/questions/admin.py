from django.contrib import admin
from questions.models import Question, Option, QuestionChain, QuestionProject

# Register your models here.
admin.site.register(Question)
admin.site.register(Option)
admin.site.register(QuestionChain)
admin.site.register(QuestionProject)
