from django.conf.urls import patterns, url
from trx_app import views

urlpatterns = patterns('',
    # url(r'^home/$', views.home, name='home'),
    url(r'^get_patient/$', views.get_patient, name='get_patient'),
    url(r'^get_audio_list/$', views.get_audio_list, name='get_audio_list'),
    url(r'^get_image_list/$', views.get_image_list, name='get_image_list'),
    url(r'^get_order/$', views.get_order, name='get_order'),
    url(r'^save_patient/$', views.save_patient, name='save_patient'),
    url(r'^save_audio/$', views.save_audio, name='save_audio'),
    url(r'^save_image/$', views.save_image, name='save_image'),
    url(r'^save_order/$', views.save_order, name='save_order'),
)
