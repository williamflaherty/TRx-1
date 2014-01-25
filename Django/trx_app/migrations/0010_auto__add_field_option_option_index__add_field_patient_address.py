# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding field 'Option.option_index'
        db.add_column('trx_app_option', 'option_index',
                      self.gf('django.db.models.fields.IntegerField')(null=True),
                      keep_default=False)

        # Adding field 'Patient.address'
        db.add_column('trx_app_patient', 'address',
                      self.gf('django.db.models.fields.CharField')(blank=True, max_length=255, default=''),
                      keep_default=False)


    def backwards(self, orm):
        # Deleting field 'Option.option_index'
        db.delete_column('trx_app_option', 'option_index')

        # Deleting field 'Patient.address'
        db.delete_column('trx_app_patient', 'address')


    models = {
        'trx_app.appdata': {
            'Meta': {'object_name': 'AppData'},
            'data': ('django.db.models.fields.TextField', [], {}),
            'end': ('django.db.models.fields.DateField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'language': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Language']"}),
            'location': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Location']"}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255', 'unique': 'True'}),
            'start': ('django.db.models.fields.DateField', [], {})
        },
        'trx_app.audio': {
            'Meta': {'object_name': 'Audio', 'unique_together': "(('patient', 'name'),)"},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Patient']"}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'})
        },
        'trx_app.chaintoquestion': {
            'Meta': {'object_name': 'ChainToQuestion'},
            'chain': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.QuestionChain']"}),
            'chain_index': ('django.db.models.fields.IntegerField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Question']"})
        },
        'trx_app.doctor': {
            'Meta': {'object_name': 'Doctor', 'unique_together': "(('firstName', 'middleName', 'lastName'),)", 'ordering': "['lastName', 'firstName']"},
            'firstName': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '255', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'middleName': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '255', 'null': 'True'})
        },
        'trx_app.history': {
            'Meta': {'object_name': 'History'},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'display_group': ('django.db.models.fields.CharField', [], {'max_length': '30'}),
            'display_text': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'key': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Patient']"}),
            'question_text': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'value': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'trx_app.image': {
            'Meta': {'object_name': 'Image', 'unique_together': "(('patient', 'name'),)"},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isProfile': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Patient']"}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'})
        },
        'trx_app.jsonfiles': {
            'Meta': {'object_name': 'JSONFiles'},
            'file_name': ('django.db.models.fields.CharField', [], {'max_length': '40'}),
            'file_text': ('django.db.models.fields.TextField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isLive': ('django.db.models.fields.BooleanField', [], {'default': 'True'})
        },
        'trx_app.laboratorydata': {
            'Meta': {'object_name': 'LaboratoryData'},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'e': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'honeycomb': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'invertedY': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'patient': ('django.db.models.fields.related.OneToOneField', [], {'unique': 'True', 'to': "orm['trx_app.Patient']"}),
            'trainTrack': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'x': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'})
        },
        'trx_app.language': {
            'Meta': {'object_name': 'Language'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255', 'unique': 'True'})
        },
        'trx_app.location': {
            'Meta': {'object_name': 'Location', 'unique_together': "(('city', 'region', 'country'),)"},
            'city': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'country': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'region': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '255'})
        },
        'trx_app.option': {
            'Meta': {'object_name': 'Option'},
            'branch': ('django.db.models.fields.related.ForeignKey', [], {'blank': 'True', 'null': 'True', 'to': "orm['trx_app.QuestionChain']", 'default': 'None'}),
            'display_text': ('django.db.models.fields.CharField', [], {'max_length': '30', 'null': 'True'}),
            'highlight': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '2', 'null': 'True', 'default': "'n'"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'option_index': ('django.db.models.fields.IntegerField', [], {'null': 'True'}),
            'question': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Question']"}),
            'text': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'translation': ('django.db.models.fields.CharField', [], {'max_length': '50', 'null': 'True'})
        },
        'trx_app.order': {
            'Meta': {'object_name': 'Order'},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'index': ('django.db.models.fields.IntegerField', [], {}),
            'isEditable': ('django.db.models.fields.BooleanField', [], {}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'orderType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.OrderType']"}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Patient']"}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        'trx_app.ordertemplate': {
            'Meta': {'object_name': 'OrderTemplate'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'index': ('django.db.models.fields.IntegerField', [], {}),
            'isEditable': ('django.db.models.fields.BooleanField', [], {}),
            'orderType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.OrderType']"}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.SurgeryType']"}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        'trx_app.ordertype': {
            'Meta': {'object_name': 'OrderType'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255', 'unique': 'True'})
        },
        'trx_app.patient': {
            'Meta': {'object_name': 'Patient', 'ordering': "['lastName', 'firstName']"},
            'address': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '255'}),
            'appointment': ('django.db.models.fields.DateTimeField', [], {'null': 'True'}),
            'birthday': ('django.db.models.fields.DateField', [], {}),
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'doctor': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Doctor']"}),
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'hasTimeout': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'location': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Location']"}),
            'middleName': ('django.db.models.fields.CharField', [], {'blank': 'True', 'max_length': '255'}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.SurgeryType']"})
        },
        'trx_app.physicalexam': {
            'Meta': {'object_name': 'PhysicalExam'},
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'key': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'patient': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.Patient']"}),
            'value': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'trx_app.question': {
            'Meta': {'object_name': 'Question'},
            'display_group': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'display_text': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question_text': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'question_type': ('django.db.models.fields.CharField', [], {'max_length': '30'}),
            'translation_text': ('django.db.models.fields.CharField', [], {'max_length': '300', 'null': 'True'})
        },
        'trx_app.questionchain': {
            'Meta': {'object_name': 'QuestionChain'},
            'chain_name': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        },
        'trx_app.questionproject': {
            'Meta': {'object_name': 'QuestionProject'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'project_name': ('django.db.models.fields.CharField', [], {'max_length': '50', 'unique': 'True'})
        },
        'trx_app.questionprojecttochain': {
            'Meta': {'object_name': 'QuestionProjectToChain'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question_chain': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.QuestionChain']"}),
            'question_set': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.QuestionProject']"}),
            'stack_index': ('django.db.models.fields.IntegerField', [], {})
        },
        'trx_app.recovery': {
            'Meta': {'object_name': 'Recovery'},
            'bloodPressure': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'heartRate': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'o2via': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'patient': ('django.db.models.fields.related.OneToOneField', [], {'unique': 'True', 'to': "orm['trx_app.Patient']"}),
            'ps': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'respiratory': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'}),
            'sao2': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True'})
        },
        'trx_app.surgerytype': {
            'Meta': {'object_name': 'SurgeryType'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255', 'unique': 'True'})
        },
        'trx_app.video': {
            'Meta': {'object_name': 'Video'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'record': ('django.db.models.fields.files.FileField', [], {'max_length': '100'}),
            'surgeryType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.SurgeryType']"}),
            'videoType': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['trx_app.VideoType']"})
        },
        'trx_app.videotype': {
            'Meta': {'object_name': 'VideoType'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255', 'unique': 'True'})
        }
    }

    complete_apps = ['trx_app']