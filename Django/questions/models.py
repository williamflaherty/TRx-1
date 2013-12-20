from django.db import models

# Create your models here.
class QuestionSet(models.Model):
  set_name = models.CharField(max_length=50, unique=True)

  def __str__(self):
    return self.set_name

class QuestionChain(models.Model):
  chain_name = models.CharField(max_length=50)

  def __str__(self):
    return self.chain_name

class Question(models.Model):
  question_type = models.CharField(max_length=5)
  display_key = models.CharField(max_length=30)
  question_text = models.CharField(max_length=300)
  display_form = models.CharField(max_length=100)

  def __str__(self):
    return self.question_text

class Option(models.Model):
  question = models.ForeignKey(Question)
  branch_y = models.ForeignKey(QuestionChain)
  text = models.CharField(max_length=50)
  display_form = models.CharField(max_length=10)

  def __str__(self):
    return self.text

class ChainToQuestion(models.Model):
  question = models.ForeignKey(Question)
  chain = models.ForeignKey(QuestionChain)
  position = models.IntegerField()
  
class QuestionSetToChain(models.Model):
  question_set = models.ForeignKey(QuestionSet)
  question_chain = models.ForeignKey(QuestionChain)
  position = models.IntegerField()
  stack = models.BooleanField()
