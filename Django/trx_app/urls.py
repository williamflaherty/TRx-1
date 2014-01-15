from django.conf.urls import patterns, url
from trx_app import api, views

urlpatterns = patterns('',
	######################
	# API
	######################
	# config
    url(r'^get_config_list/$', api.get_config_list, name='get_config_list'),
    url(r'^get_config/$', api.get_config, name='get_config'),

    # patients
    url(r'^get_patient/$', api.get_patient, name='get_patient'),
    url(r'^save_patient/$', api.save_patient, name='save_patient'),

    # audio
    url(r'^get_audio_list/$', api.get_audio_list, name='get_audio_list'),
    url(r'^save_audio/$', api.save_audio, name='save_audio'),

    # images
    url(r'^get_image_list/$', api.get_image_list, name='get_image_list'),
    url(r'^save_image/$', api.save_image, name='save_image'),

    # orders
    url(r'^get_order/$', api.get_order, name='get_order'),
    url(r'^save_order/$', api.save_order, name='save_order'),

	######################
	# Config # CONVTAG
	######################
    url(r'^$', views.projectHome, name='projectHome'),
    url(r'^chainHome/$', views.chainHome, name='chainHome'),
    url(r'^questionHome/$', views.questionHome, name='questionHome'),

    #project
    url(r'addProject/$', views.addProject, name='addProject'),
    url(r'deleteProject/(?P<project_index>\d+)/$', views.deleteProject, name='deleteProject'),
    url(r'saveProject/(?P<project_index>\d+)/$', views.saveProject, name='saveProject'),
    url(r'editProject/(?P<project_index>\d+)/$', views.editProject, name='editProject'),

    #chain
    url(r'deleteChain/(?P<chain_index>\d+)/$', views.deleteChain,name='deleteChain'),
    url(r'editChain/(?P<chain_index>\d+)/$', views.editChain,name='editChain'),
    url(r'addChain/$', views.addChain, name='addChain'),

    url(r'saveChain/(?P<chain_index>\d+)/$', views.saveChain, name='saveChain'),
    url(r'editProject/(?P<project_index>\d+)/editChain/(?P<chain_index>\d+)/$', views.editChain, name='editChain'),

    #question
    url(r'deleteQuestion/(?P<question_index>\d+)/$', views.deleteQuestion,name='deleteQuestion'),
    url(r'editQuestion/(?P<question_index>\d+)/$', views.editQuestion,name='editQuestion'),
    url(r'editQuestion/$', views.addQuestion,name='editQuestion'),
    url(r'addQuestion/$', views.addQuestion,name='addQuestion'),

    #surgery
    url(r'^surgeryHome/$', views.surgeryHome, name='surgeryHome'),
    url(r'^deleteSurgery/(?P<surgery_index>\d+)/$', views.deleteSurgery, name='deleteSurgery'),

    #doctor
    url(r'^doctorHome/$', views.doctorHome, name='doctorHome'),
    url(r'^deleteDoctor/(?P<doctor_index>\d+)/$', views.deleteDoctor, name='deleteDoctor'),
    
    #json file
    url(r'^fileHome/$', views.fileHome, name='fileHome'),
    url(r'^fileHome/(?P<project_index>\d+)/$', views.fileHome, name='generateJSON'),
    url(r'fileView/(?P<file_index>\d+)/$', views.fileView, name='fileView'),
    url(r'^deleteFile/(?P<file_index>\d+)/$', views.deleteFile, name='deleteFile'),
)
