from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django import forms
from questions.models import QuestionSet, QuestionChain

# Create your views here.
def home(request):
  return render(request, 'questions/home.html')

#pages seen from Home
def index(request):
  return render(request, 'questions/index.html')
def existingProject(request):
  return render(request, 'questions/existing.html')
#def addProject(request):
#  return render(request, 'questions/new.html')

def addProject(request):
  if request.method == 'POST': # If the form has been submitted...
    form = NewProjectForm(request.POST) # A form bound to the POST data
    if form.is_valid(): # All validation rules pass
     # Process the data in form.cleaned_data
       # ...
      #return HttpResponseRedirect('/thanks/') # Redirect after POST
      name = request.POST['name']
      qs = QuestionSet(set_name=name)
      qs.save()
      #request.session['project_name'] = request.POST['name']
      #request.session['index'] = qs.id
      return HttpResponseRedirect("/questions/editSet/%s/" % qs.id)#check if worked
  else:
    form = NewProjectForm() # An unbound form
  return render(request, 'questions/addProject.html', {
    'form': form,
  })


def addChain(request, set_index):
  if request.method == 'POST': # If the form has been submitted...
    form = NewChainForm(request.POST) # A form bound to the POST data
    if form.is_valid(): # All validation rules pass
     # Process the data in form.cleaned_data
       # ...
      #return HttpResponseRedirect('/thanks/') # Redirect after POST
      name = request.POST['name']
      qc = QuestionChain(chain_name=name)
      qc.save()

      # Set index?

      #request.session['project_name'] = request.POST['name']
      #request.session['index'] = qc.id
      return HttpResponseRedirect("/questions/editSet/%s/editChain/%s/" % (set_index, qc.id))#check if worked
  else:
    form = NewChainForm() # An unbound form
  return render(request, 'questions/addChain.html', {
    'form': form,
  })


def editChain(request,set_index,chain_index):
  return render(request, 'questions/editChain.html', { "set_index": set_index, "chain_index" : chain_index })

def editQuestion(request,question_index):
  return "sup"


def add(request):
  return render(request, 'questions/add.html')
def chain(request):
  return render(request, 'questions/chain.html')
def editSet(request,set_index):
  #dic = {"project_name" : request.session.get('project_name'), 
         #"index" : request.session.get('index'),
         #"form": NewChainForm(request.POST)}
  dic = {"set_index":set_index, "form": NewChainForm(request.POST)}
  return render(request, 'questions/editSet.html', dic)

class NewProjectForm(forms.Form):
  name = forms.CharField(max_length=100)
class NewChainForm(forms.Form):
  name = forms.CharField(max_length=100)

