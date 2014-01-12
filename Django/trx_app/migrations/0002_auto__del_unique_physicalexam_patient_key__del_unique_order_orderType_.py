# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Removing unique constraint on 'Order', fields ['orderType', 'patient', 'index']
        db.delete_unique(u'trx_app_order', ['orderType_id', 'patient_id', 'index'])

        # Removing unique constraint on 'PhysicalExam', fields ['patient', 'key']
        db.delete_unique(u'trx_app_physicalexam', ['patient_id', 'key'])


    def backwards(self, orm):
        # Adding unique constraint on 'PhysicalExam', fields ['patient', 'key']
        db.create_unique(u'trx_app_physicalexam', ['patient_id', 'key'])

        # Adding unique constraint on 'Order', fields ['orderType', 'patient', 'index']
        db.create_unique(u'trx_app_order', ['orderType_id', 'patient_id', 'index'])


    models = {
        u'trx_app.appdata': {
            'Meta': {'object_name': 'AppData'},
            'data': ('django.db.models.fields.TextField', [], {}),
            'end': ('django.db.models.fields.DateField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'language': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Language']"}),
            'location': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Location']"}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'}),
            'start': ('django.db.models.fields.DateField', [], {})
        },
        u'trx_app.audio': {
            'Meta': {'unique_together': "(('patient', 'name'),)", 'object_name': 'Audio'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Patient']"}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'})
        },
        u'trx_app.doctor': {
            'Meta': {'ordering': "['lastName', 'firstName']", 'unique_together': "(('firstName', 'middleName', 'lastName'),)", 'object_name': 'Doctor'},
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'middleName': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'})
        },
        u'trx_app.history': {
            'Meta': {'unique_together': "(('patient', 'key'),)", 'object_name': 'History'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'key': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Patient']"}),
            'value': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        u'trx_app.image': {
            'Meta': {'unique_together': "(('patient', 'name'),)", 'object_name': 'Image'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isProfile': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Patient']"}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'})
        },
        u'trx_app.laboratorydata': {
            'Meta': {'object_name': 'LaboratoryData'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'e': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'honeycomb': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'invertedY': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'patient': ('django.db.models.fields.related.OneToOneField', [], {'to': u"orm['trx_app.Patient']", 'unique': 'True'}),
            'trainTrack': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'x': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'})
        },
        u'trx_app.language': {
            'Meta': {'object_name': 'Language'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        },
        u'trx_app.location': {
            'Meta': {'unique_together': "(('city', 'region', 'country'),)", 'object_name': 'Location'},
            'city': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'country': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'region': ('django.db.models.fields.CharField', [], {'max_length': '255', 'blank': 'True'})
        },
        u'trx_app.order': {
            'Meta': {'object_name': 'Order'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'index': ('django.db.models.fields.IntegerField', [], {}),
            'isEditable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'orderType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.OrderType']"}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Patient']"}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        u'trx_app.ordertemplate': {
            'Meta': {'object_name': 'OrderTemplate'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'index': ('django.db.models.fields.IntegerField', [], {}),
            'isEditable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'orderType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.OrderType']"}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.SurgeryType']"}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        u'trx_app.ordertype': {
            'Meta': {'object_name': 'OrderType'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        },
        u'trx_app.patient': {
            'Meta': {'ordering': "['lastName', 'firstName']", 'object_name': 'Patient'},
            'birthday': ('django.db.models.fields.DateField', [], {}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'doctor': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Doctor']"}),
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'hasTimeout': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'location': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Location']"}),
            'middleName': ('django.db.models.fields.CharField', [], {'max_length': '255', 'blank': 'True'}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.SurgeryType']"})
        },
        u'trx_app.physicalexam': {
            'Meta': {'object_name': 'PhysicalExam'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'key': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Patient']"}),
            'value': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        u'trx_app.recovery': {
            'Meta': {'object_name': 'Recovery'},
            'bloodPressure': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'heartRate': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'o2via': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'patient': ('django.db.models.fields.related.OneToOneField', [], {'to': u"orm['trx_app.Patient']", 'unique': 'True'}),
            'ps': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'respiratory': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'sao2': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'})
        },
        u'trx_app.surgerytype': {
            'Meta': {'object_name': 'SurgeryType'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        },
        u'trx_app.video': {
            'Meta': {'object_name': 'Video'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.SurgeryType']"}),
            'videoType': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.VideoType']"})
        },
        u'trx_app.videotype': {
            'Meta': {'object_name': 'VideoType'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        }
    }

    complete_apps = ['trx_app']