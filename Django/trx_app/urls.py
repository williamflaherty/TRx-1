from django.conf.urls import patterns, url
from trx_app import views

urlpatterns = patterns('',
    # url(r'^home/$', views.home, name='home'),
    url(r'^get_patient/$', views.get_patient, name='get_patient'),
)
