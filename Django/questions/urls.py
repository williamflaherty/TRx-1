
from django.conf.urls import patterns, url

from questions import views

urlpatterns = patterns('',
    url(r'^$', views.home, name='home'),
    url(r'^index/$', views.index, name='index'),
    url(r'^add/$', views.add, name='add'),
    url(r'^chain/$', views.chain, name='chain'),
    url(r'^addProject/$', views.addProject, name='addProject'),
    #url(r'^(?P<QuestionChain_id>\d+)/edit/$', views.editChain, name='editChain'),

    url(r'^editSet/(?P<set_index>\d+)/$', views.editSet, name='editSet'),
    url(r'^editSet/(?P<set_index>\d+)/editChain/(?P<chain_index>\d+)/$', views.editChain, name='editChain'),
    url(r'^editSet/(?P<set_index>\d+)/addChain/$', views.addChain, name='addChain'),
    url(r'^editSet/(?P<set_index>\d+)/editChain/(?P<chain_index>\d+)/editQuestion/(?P<question_index>\d+)/$', views.editQuestion, name='editQuestion'),

    #url(r'^addChain/$', views.addChain, name='addChain'),
    
    # ex: /polls/5/
    #url(r'^(?P<poll_id>\d+)/$', views.detail, name='detail'),
    # ex: /polls/5/results/
    #url(r'^(?P<poll_id>\d+)/results/$', views.results, name='results'),
    # ex: /polls/5/vote/
    #url(r'^(?P<poll_id>\d+)/vote/$', views.vote, name='vote'),
)
