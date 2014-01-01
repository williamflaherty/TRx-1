from django.db import models

# Create your models here.
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
  branch = models.ForeignKey(QuestionChain, blank=True, null=True)
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

class SurgeryType(models.Model):
  surgery_name = models.CharField(max_length=30, unique=True)

class JSONFiles(models.Model):
  file_name = models.CharField(max_length=40)
  file_text = models.TextField()

