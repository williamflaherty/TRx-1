from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django import forms
from django.forms.formsets import formset_factory
from django.db.models import Q
from django.core import serializers
from trx_app.models import QuestionProject, QuestionChain, Question, Option, QuestionProjectToChain, ChainToQuestion, SurgeryType, JSONFiles, Doctor
import json

#################################### Home Pages ######################################

def projectHome(request):
  context = {}
  if request.method == 'POST':
    form = NewProjectForm(request.POST)
    if form.is_valid():
      name = request.POST['name']
      qp = QuestionProject(project_name=name)
      qp.save()

  context["projects"] = QuestionProject.objects.all()
  context["form"] = NewProjectForm()
  context["menu_location"] = "project"
  return render(request, 'trx_app/projectHome.html', context)

def chainHome(request):
  context = {}
  if request.method == 'POST':
    form = NewChainForm(request.POST)
    if form.is_valid():
      name = request.POST['name']
      qc = QuestionChain(chain_name=name)
      qc.save()

  context["chains"] = QuestionChain.objects.all()
  context["form"] = NewChainForm()
  context["menu_location"] = "chain"
  context["previous_page"] = previous_page(request.path)
  return render(request, 'trx_app/chainHome.html', context)


def questionHome(request):
  context = { "questions": Question.objects.all() }
  context["menu_location"] = "questions"
  context["previous_page"] = previous_page(request.path)
  return render(request, 'trx_app/questionHome.html', context)


def surgeryHome(request):
  context = {}
  if request.method == 'POST':
    print("in surgeryHome below POST")
    form = NewSurgeryForm(request.POST)
    if form.is_valid():
      name = request.POST['name']
      ob = SurgeryType(name=name)
      ob.save()
      print("just saved surgery name: ", name)

  context["surgeries"] = SurgeryType.objects.all()
  context["form"] = NewSurgeryForm()
  context["menu_location"] = "surgery"
  context["previous_page"] = previous_page(request.path)
  return render(request, 'trx_app/surgeryHome.html', context)


def doctorHome(request):
  context = {}
  if request.method == 'POST':
    form = NewDoctorForm(request.POST)
    if form.is_valid():
      name = request.POST['name']
      ob = Doctor(lastName=name)
      ob.save()

  context["doctors"] = Doctor.objects.all()
  context["form"] = NewDoctorForm()
  context["menu_location"] = "doctor"
  context["previous_page"] = previous_page(request.path)
  return render(request, 'trx_app/doctorHome.html', context)


def fileHome(request, project_index=-1):
  context = {}
  print("in fileHOme with project_index: ", project_index)
  if project_index != -1 and request.method == 'POST':
    print("in fileHOme with project_index: ", project_index)
    project = QuestionProject.objects.get(pk=project_index)
    json = generateJSON(request, project_index)
    f = JSONFiles(file_name=project.project_name,file_text=json)
    f.save()

  context["files"] = JSONFiles.objects.all()
  context["menu_location"] = "file"
  context["previous_page"] = previous_page(request.path)
  return render(request, 'trx_app/fileHome.html', context)



#################################### Add Pages  ######################################

def addProject(request):
  if request.method == 'POST': # If the form has been submitted...
    form = NewProjectForm(request.POST) # A form bound to the POST data
    if form.is_valid(): # All validation rules pass
      name = request.POST['name']
      qs = QuestionProject(project_name=name)
      qs.save()
      #context["previous_page"] = previous_page(request.path)
      # is this ever called?
      return HttpResponseRedirect("/editProject/%s/" % qs.id)#check if worked
  else:
    form = NewProjectForm() # An unbound form
  return render(request, 'trx_app/add.html', {
    'form': form,
  })


def addChain(request):
  if request.method == 'POST': # If the form has been submitted...
    form = NewChainForm(request.POST) # A form bound to the POST data
    if form.is_valid(): # All validation rules pass
      name = request.POST['name']
      qc = QuestionChain(chain_name=name)
      qc.save()
      #context["previous_page"] = previous_page(request.path)
      return HttpResponseRedirect("%seditChain/%s/" % (previous_page(request.path), qc.id))#check if worked
  else:
    form = NewChainForm() # An unbound form
  return render(request, 'trx_app/addChain.html', {
    'form': form,
  })




def addQuestion(request):
  return editQuestion(request=request, question_index=-1)

# also editQuestion
def editQuestion(request, question_index):

  NewOptionsFormset = formset_factory(NewOptionForm, max_num=15, extra=0)

  if request.method == 'POST': # receiving question info
    print(request.POST)

    question_form = NewQuestionForm(request.POST)
    options_formset = NewOptionsFormset(request.POST, request.FILES)

    if question_form.is_valid() and options_formset.is_valid():

      if question_index == -1: # Saving new question
        q = question_form.save()
        print("saving question...")

      else: # Updating existing question
        q = Question.objects.get(pk=question_index)
        form = NewQuestionForm(request.POST, instance=q)
        form.save()

        Option.objects.filter(question=question_index).delete()

      for option_index,form in enumerate(options_formset.forms):
        print("form=>")
        #print("form=>",form)
        option = form.save(commit=False) #commit = false
        option.question = q
        option.option_index = option_index
        print(option.text)
        option.save()
        
      #redirect to options page unless fill in the blank
      #return HttpResponseRedirect(previous_page(request.path))
      return HttpResponseRedirect('/trx_app/questionHome')
      
  else: # render page
    if question_index == -1:
      NewOptionsFormset = formset_factory(NewOptionForm, max_num=15, extra=1)
      question_form = NewQuestionForm()
      options_formset = NewOptionsFormset()
    else: ##** The else statement needs to load the forms with data from database
      question = get_object_or_404(Question, id=question_index)
      options =  Option.objects.all().filter(question=question).order_by('option_index').values()

      #branch select couldn't find option['branch_id'] so insert option['branch']
      for option in options:
        option['branch'] = option['branch_id']

      if not options:
        NewOptionsFormset = formset_factory(NewOptionForm, max_num=15, extra=1)
      else:
        NewOptionsFormset = formset_factory(NewOptionForm, max_num=15, extra=0)

      question_form = NewQuestionForm(instance=question)
      print("options ===> ", options)
      options_formset = NewOptionsFormset(initial=options)
      #print(options_formset)
  context = { 'question_form': question_form, 'options_formset': options_formset}
  context['previous_page'] = previous_page(request.path)
  return render(request, 'trx_app/addQuestion.html', context)



###################################  Save Pages     ##################################

# Not finished. Receiving a list of (hopefully) sorted
# question_chain ids that should be saved to the project_index
def saveProject(request, project_index):
  project_index = int(project_index)
  project_ids = request.POST.getlist('used_ids[]')
#  for p in project_ids: print(p)

  QuestionProjectToChain.objects.filter(question_set=project_index).delete()
  for i,p in enumerate(project_ids):
    p = int(p)
    print(project_index, p, i)
    try:
      qp_to_qc = QuestionProjectToChain(question_set_id=project_index, question_chain_id=p, stack_index=i)
    except Exception as e:
      print(e)
    qp_to_qc.save()

  return HttpResponse('')


def saveChain(request, chain_index):
  chain_index = int(chain_index)
  chain_ids = request.POST.getlist('used_ids[]')
  print(str(chain_ids) + "testing")
  ChainToQuestion.objects.filter(chain=chain_index).delete()
  for i,p in enumerate(chain_ids):
    p = int(p)
    #print(chain_index, p, i)
    try:
      qc_to_q = ChainToQuestion(chain_id=chain_index, question_id=p, chain_index=i)
    except Exception as e:
      print(e)
    qc_to_q.save()

  return HttpResponse('')

###################################  Edit Pages     ##################################

# TODO: Works, but hackish. Fix up later, when know how.
def editProject(request,project_index):
  project_index = int(project_index)
  dict = {}
  dict["project_index"] = project_index
  dict["project_name"] = QuestionProject.objects.get(id=project_index).project_name
  dict["form"] = NewChainForm()
  dict["previous_page"] = previous_page(request.path)

  # Want used_chains to contains the question_chains that are used in the current project
  # and ununsed_chains to contain every other question_chain
  # used_qc_ids is a list of question_chain objects that relate to the matching QuestionProjectToChain entries
  qp_to_chain = QuestionProjectToChain.objects.all().filter(question_set=project_index)

  used_qc_ids = [e.question_chain_id for e in qp_to_chain]

  #for e in used_qc_ids: print e

  question_chains = QuestionChain.objects.all()

  # The idea is to sort the chains currently in use in the project by stack index. Untested as of yet
  dict["used_chains"] = sorted([e for e in question_chains if e.id in used_qc_ids],
      key=lambda k: [f for f in qp_to_chain if f.question_chain_id == k.id][0].stack_index)
  dict["unused_chains"] = sorted(list(set(question_chains)-set(dict["used_chains"])), key=lambda k: k.chain_name) # alphabetical

  return render(request, 'trx_app/editProject.html', dict)


def editChain(request,chain_index,project_index=0):
  chain_index = int(chain_index)
  dict = {}
  dict["chain_index"] = chain_index
  dict["chain_name"] = QuestionChain.objects.get(id=chain_index).chain_name

  chain_to_q = ChainToQuestion.objects.all().filter(chain=chain_index)
  used_question_ids = [e.question_id for e in chain_to_q]

  questions = Question.objects.all()

  dict["used_questions"] = sorted([e for e in questions if e.id in used_question_ids],
      key=lambda k: [f for f in chain_to_q if f.question_id == k.id][0].chain_index)
  dict["unused_questions"] = sorted(list(set(questions)-set(dict["used_questions"])), key=lambda k: k.display_group)
  dict["previous_page"] = previous_page(request.path)

  return render(request, 'trx_app/editChain.html', dict)



def editOptions(request,chain_index,project_index,question_index):
  return render(request, 'trx_app/editOptions.html', { "project_index": project_index, "chain_index": chain_index, "question_index": question_index })


###################################  Delete Methods ##################################

def deleteProject(request, project_index):
  project = QuestionProject.objects.get(id = project_index)
  project.delete()
  return projectHome(request)


def deleteChain(request, chain_index):
  chain = QuestionChain.objects.get(id = chain_index)
  chain.delete()
  return chainHome(request)

def deleteQuestion(request, question_index):
  question = Question.objects.get(id = question_index)
  question.delete()
  print("request path", request.path)
  return HttpResponseRedirect('/trx_app/questionHome/')

def deleteSurgery(request, surgery_index):
  surgery = SurgeryType.objects.get(id = surgery_index)
  surgery.delete()
  return HttpResponseRedirect('/trx_app/surgeryHome/')

def deleteDoctor(request, doctor_index):
  doctor = Doctor.objects.get(id = doctor_index)
  doctor.delete()
  return HttpResponseRedirect('/trx_app/doctorHome/')

def deleteFile(request, file_index):
  json = JSONFiles.objects.get(id = file_index)
  json.delete()
  return HttpResponseRedirect('/trx_app/fileHome/')

###################################  Forms          ##################################

class NewProjectForm(forms.Form):
  name = forms.CharField(max_length=50)
class NewChainForm(forms.Form):
  name = forms.CharField(max_length=50)
class NewSurgeryForm(forms.Form):
  name = forms.CharField(max_length=40)
class NewDoctorForm(forms.Form):
  name = forms.CharField(max_length=40)

class NewQuestionForm(forms.ModelForm):
  class Meta:
    model= Question
    widgets = {
        'question_text': forms.Textarea(attrs={'cols':80, 'rows':2}),
        'translation_text': forms.Textarea(attrs={'cols':80, 'rows':2}),
        'display_text': forms.TextInput(attrs={'size':30}),
    }

class NewOptionForm(forms.ModelForm):
  class Meta:
    model = Option
    exclude = ['question', 'option_index']
    widgets = {
        'text': forms.TextInput(attrs={'size':40}),
        'translation': forms.TextInput(attrs={'size':40}),
        'highlight': forms.Select(),
    }



###################################  Miscellaneus   ##################################

def generateJSON(request, project_index):
  
  question_project = {"stack_questions":[]}
  used_stack_ids = []

  for qp_to_c in sorted(QuestionProjectToChain.objects.all().filter(question_set_id=project_index), key=lambda k: int(k.stack_index)):
    question_chain = packChain(qp_to_c.question_chain_id)
    question_chain["stack_index"] = int(qp_to_c.stack_index)
    question_project["stack_questions"].append(question_chain)

    used_stack_ids.append(int(qp_to_c.question_chain_id))

  #for chain in QuestionProjectToChain.objects.filter(~Q(question_set_id=project_index)):
  #for chain in QuestionProjectToChain.objects.all().exclude(question_set_id=project_index):
  branch_questions = []
  for chain in [e for e in QuestionChain.objects.all() if int(e.id) not in used_stack_ids]:
    question_chain = packChain(chain.id)
    branch_questions.append(question_chain)
    
  question_project["branch_questions"] = branch_questions

  #question_project["surgeries"] = SurgeryType.objects..values()
  question_project["surgeries"] = list(SurgeryType.objects.all().values())
  question_project["doctors"] = list(Doctor.objects.all().values())

  s =  json.dumps(question_project, sort_keys=True, indent=4).splitlines()
  return '\n'.join([l.rstrip() for l in s])


def packChain(question_chain_id):
  question_chain = {"questions":[]}
  question_chain["id"] = question_chain_id
  for c_to_q in sorted(ChainToQuestion.objects.all().filter(chain_id=question_chain_id), key=lambda k: int(k.chain_index)):
    question = packQuestion(c_to_q)
    question_chain["questions"].append(question)
  return question_chain


def packQuestion(question_object):
  chain_index = int(question_object.chain_index)
  question_id = question_object.question_id
  options = list(Option.objects.filter(question_id=question_id).values())

  question = Question.objects.filter(pk=question_id).values()[0]
  question["options"] = options
  question["chain_index"] = chain_index
  return question

  #question_chain["question"][chain_index] = question
#question_project["question_chain"][stack_index] = question_chain

def fileView(request,file_index):
  f = JSONFiles.objects.get(pk=file_index)
  return HttpResponse(f.file_text, content_type='application/json')


def previous_page(url):
  if url[-1] != '/':
    url += '/'
  url = url.replace('//', '/')
  chopped = url.split('/')
  if chopped[-2].isdigit():
    answer = '/'.join(chopped[0:-3])+'/'
  else:
    answer = '/'.join(chopped[0:-2])+'/'
  return answer
