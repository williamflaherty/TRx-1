from django.db import models
import uuid

###########################
# API
###########################
#TODO: because of different languages, we need to check the encoding on the tables (for now just use romance lang)
def file_path(instance, filename):
    extension = filename.rsplit(".", 1)[1]
    return str(uuid.uuid1()) + "." + extension

class SurgeryType(models.Model):
    name = models.CharField(max_length = 255, unique = True)
    # isCurrent = models.BooleanField() #TODO: no more isCurrent here too?

    def __unicode__(self):
        return self.name

class OrderType(models.Model):
    name = models.CharField(max_length = 255, unique = True)

    def __unicode__(self):
        return self.name

class VideoType(models.Model):
    name = models.CharField(max_length = 255, unique = True)

    def __unicode__(self):
        return self.name

class Location(models.Model):
    city = models.CharField(max_length = 255)
    region = models.CharField(max_length = 255, blank = True)
    country = models.CharField(max_length = 255)
    # TODO: go through and pull out all necessary isCurrents, will be handled in other API
    # isCurrent = models.BooleanField(default = True)

    def __unicode__(self):
        if self.region:        
            return "{0} {1}, {2}".format(self.city, self.region, self.country)
        else:
            return "{0}, {1}".format(self.city, self.country)

    class Meta:
        unique_together = ('city', 'region', 'country')

class Doctor(models.Model):
    firstName = models.CharField(max_length = 255)
    middleName = models.CharField(max_length = 255, null = True, blank = True)
    lastName = models.CharField(max_length = 255)
    # isCurrent = models.BooleanField()

    def __unicode__(self):
        return "{0} {1}".format(self.firstName, self.lastName)

    class Meta:
        ordering = ['lastName', 'firstName']
        unique_together = ('firstName', 'middleName', 'lastName')

class Patient(models.Model):
    firstName = models.CharField(max_length = 255)
    middleName = models.CharField(max_length = 255, blank = True)
    lastName = models.CharField(max_length = 255)
    birthday = models.DateField()
    surgeryType = models.ForeignKey(SurgeryType)
    doctor = models.ForeignKey(Doctor)
    location = models.ForeignKey(Location)
    hasTimeout = models.BooleanField(default = False)
    isCurrent = models.BooleanField(default = True)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return "{0} {1}".format(self.firstName, self.lastName)

    # this is a custom save method so that there is only one isCurrent for any person/surgeryType combo
    # TODO: this needs to be tested
    def save(self, *args, **kwargs):

        surgeryRecords = Patient.objects.filter(firstName=self.firstName, middleName=self.middleName, lastName=self.lastName, 
            birthday=self.birthday, surgeryType=self.surgeryType, isCurrent=True).exclude(pk=self.pk)
        
        if not surgeryRecords:
            super(Patient, self).save(*args, **kwargs)
        else:
            raise Exception, "A patient can only have one current record for this surgery type."

    class Meta:
        ordering = ['lastName', 'firstName']

class Audio(models.Model):
    name = models.CharField(max_length = 255)
    patient = models.ForeignKey(Patient)
    record = models.FileField(upload_to = file_path)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        unique_together = ('patient', 'name')
        verbose_name_plural = "Audio"
     
class Image(models.Model):
    name = models.CharField(max_length = 255)
    patient = models.ForeignKey(Patient)
    record = models.FileField(upload_to = file_path)
    isProfile = models.BooleanField(default = True)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return self.name

    class Meta:
        unique_together = ('patient', 'name')

class Order(models.Model):
    orderType = models.ForeignKey(OrderType)
    patient = models.ForeignKey(Patient)
    text = models.TextField()
    index = models.IntegerField()
    isEditable = models.BooleanField()
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return "{0} for {1} ({2})".format(self.orderType, self.patient, self.index)

    # class Meta:
        # unique_together = ('orderType', 'patient', 'index')

    # this is a custom save method so that there is only one ordertype/patient/index combo cuz Django Rest Framework is a bitch
    # TODO: this needs to be tested
    def save(self, *args, **kwargs):

        order = Order.objects.filter(orderType=self.orderType, patient=self.patient, index=self.index).exclude(pk=self.pk)
        
        if not order:
            super(Order, self).save(*args, **kwargs)
        else:
            raise Exception, "This is a duplicate order entry."

class OrderTemplate(models.Model):
    surgeryType = models.ForeignKey(SurgeryType)
    orderType = models.ForeignKey(OrderType)
    text = models.TextField()
    index = models.IntegerField()
    isEditable = models.BooleanField()
    # isCurrent = models.BooleanField() # TODO: no more isCurrent?

    def __unicode__(self):
        return "{0} for {1} ({2})".format(self.OrderType, self.surgeryType, self.index)

    #TODO: if we are doing away with the isCurrent, this save method is invalid + prolly just letting them store blindly
    # # this is a custom save ensuring there is only one current record for an orderType/surgerType/index combo
    # # TODO: this needs to be tested
    # def save(self, *args, **kwargs):

    #     templates = OrderTemplate.objects.filter(surgeryType=self.surgeryType, orderType=self.orderType, index=self.index, 
    #         isCurrent=True).exclude(pk=self.pk)
        
    #     if not templates:
    #         super(OrderTemplate, self).save(*args, **kwargs)
    #     else:
    #         raise Exception, "There can only be one current order template for this surgery type at this index."

class PhysicalExam(models.Model):
    patient = models.ForeignKey(Patient)
    key = models.CharField(max_length = 255)
    value = models.CharField(max_length = 255)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return "{0} for {1}".format(self.key, self.patient)

    # class Meta:
    #     unique_together = ('patient', 'key')

    # TODO: this is a custom save method to ensure only one key entry per patient (because DRF is stupid)
    def save(self, *args, **kwargs):

        physical = PhysicalExam.objects.filter(key=self.key, patient=self.patient).exclude(pk=self.pk)
        
        if not physical:
            super(PhysicalExam, self).save(*args, **kwargs)
        else:
            raise Exception, "This is a duplicate physical exam entry."

class Recovery(models.Model):
    patient = models.OneToOneField(Patient)
    bloodPressure = models.CharField(max_length = 255, null = True)
    heartRate = models.CharField(max_length = 255, null = True)
    respiratory = models.CharField(max_length = 255, null = True)
    sao2 = models.CharField(max_length = 255, null = True)
    o2via = models.CharField(max_length = 255, null = True)
    ps = models.CharField(max_length = 255, null = True)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return "Recovery for {1}'s {2}".format(self.patient.lastName, self.patient.surgeryType)

    class Meta:
        verbose_name_plural = "Recoveries"
     
class Video(models.Model):
    surgeryType = models.ForeignKey(SurgeryType)
    videoType = models.ForeignKey(VideoType)
    record = models.FileField(upload_to = file_path)
    name = models.CharField(max_length = 255)
    # isCurrent = models.BooleanField() #TODO: see all the other isCurrent todos

    def __unicode__(self):
        return self.name
    
    # TODO: no longer have isCurrent...what logic needs to change
    # # this is a custom save ensuring there is only one current record for a videoType/surgeryType combo
    # # TODO: this needs to be tested
    # def save(self, *args, **kwargs):

    #     videos = Video.objects.filter(surgeryType=self.surgeryType, videoType=self.videoType, isCurrent=True).exclude(pk=self.pk)
        
    #     if not videos:
    #         super(Video, self).save(*args, **kwargs)
    #     else:
            # raise Exception, "There can only be one current video for this surgery type and video type."

class History(models.Model):
    patient = models.ForeignKey(Patient)
    key = models.CharField(max_length = 255)
    value = models.CharField(max_length = 255)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    # TODO: we don't need to keep the following if summary pages won't be generated by History but solely by JSON
    question_text = models.CharField(max_length=300)
    display_text = models.CharField(max_length=100)
    display_group = models.CharField(max_length=30)

    def __unicode__(self):
        return "{0} for {1}".format(self.key, self.patient.lastName)

    # this is a custom save method so that there is only one ordertype/patient/index combo cuz Django Rest Framework is a bitch
    # TODO: this needs to be tested
    def save(self, *args, **kwargs):

        history = History.objects.filter(patient=self.patient, key=self.key).exclude(pk=self.pk)
        
        if not history:
            super(History, self).save(*args, **kwargs)
        else:
            raise Exception, "This is a duplicate history entry."
    class Meta:
        # unique_together = ('patient', 'key')
        verbose_name_plural = "Histories"
     
# TODO: I need the official names of the 5 hieroglyphs
class LaboratoryData(models.Model):
    patient = models.OneToOneField(Patient)
    trainTrack = models.CharField(max_length = 255, null = True)
    e = models.CharField(max_length = 255, null = True)
    honeycomb = models.CharField(max_length = 255, null = True)
    invertedY = models.CharField(max_length = 255, null = True)
    x = models.CharField(max_length = 255, null = True)
    lastModified = models.DateTimeField(auto_now = True)
    created = models.DateTimeField(auto_now_add = True)

    def __unicode__(self):
        return self.patient
    
    class Meta:
        verbose_name_plural = "LaboratoryData"
     
class Language(models.Model):
    name = models.CharField(max_length = 255, unique = True)

    def __unicode__(self):
        return self.name

#TODO: ask John what is needed to identify a trip
#TODO: I don't know that a full start - end date is necessary (or useful?)
class AppData(models.Model):
    name = models.CharField(max_length = 255, unique = True)
    location = models.ForeignKey(Location)
    language = models.ForeignKey(Language)
    data = models.TextField()
    start = models.DateField()
    end = models.DateField()

    def __unicode__(self):
        return self.name
    
    class Meta:
        verbose_name_plural = "AppData"

###########################
# Config # CONVTAG
###########################
class QuestionProject(models.Model):
  project_name = models.CharField(max_length=50, unique=True)

  def __str__(self):
    return self.set_name

class QuestionChain(models.Model):
  chain_name = models.CharField(max_length=50)

  def __str__(self):
    return self.chain_name

question_types = (
    ('fib', 'fill-in-the-blank'),
    ('yn', 'yes/no'),
    ('cb', 'check box'),
    ('cbb', 'check box with blank'),)

highlight_colors = (
    ('n', 'no highlight'),
    ('r', 'red'),
    ('b', 'bold'),)

branch_choice = (
    (None, 'No branch'),)

class Question(models.Model):
  question_type = models.CharField(max_length=5,choices=question_types)
  question_text = models.CharField(max_length=300)
  translation_text = models.CharField(max_length=300, null=True)
  display_text = models.CharField(max_length=100)
  display_group = models.CharField(max_length=30)

  def __str__(self):
    return self.question_text

class Option(models.Model):
  question = models.ForeignKey(Question)
  branch = models.ForeignKey(QuestionChain, blank= True, null=True, default=None)
  text = models.CharField(max_length=50)
  translation = models.CharField(max_length=50, null=True)
  display_text = models.CharField(max_length=30, null=True)
  highlight = models.CharField(max_length=2,choices=highlight_colors, blank=True,null=True, default='n')

  def __str__(self):
    return self.text

class ChainToQuestion(models.Model):
  chain = models.ForeignKey(QuestionChain)
  question = models.ForeignKey(Question)
  chain_index = models.IntegerField()

class QuestionProjectToChain(models.Model):
  question_set = models.ForeignKey(QuestionProject)
  question_chain = models.ForeignKey(QuestionChain)
  stack_index = models.IntegerField()

# CONVTAG
class SurgeryType_Config(models.Model):
  surgery_name = models.CharField(max_length=30, unique=True)

# CONVTAG
class Doctor_Config(models.Model):
  doctor_name = models.CharField(max_length=30, unique=True)

class JSONFiles(models.Model):
  file_name = models.CharField(max_length=40)
  file_text = models.TextField()
  isLive = models.BooleanField(default = True)

  # TODO: consider making the file_name unique
  # the generator doesn't make test X if the test is there, and it does not override the old file
  # the first is probably the better solution
  # or just insisting that it should be unique and allowing the user to input a name






     
