# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'SurgeryType_Config'
        db.create_table(u'trx_app_surgerytype_config', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('surgery_name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=30)),
        ))
        db.send_create_signal(u'trx_app', ['SurgeryType_Config'])

        # Adding model 'ChainToQuestion'
        db.create_table(u'trx_app_chaintoquestion', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('chain', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.QuestionChain'])),
            ('question', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Question'])),
            ('chain_index', self.gf('django.db.models.fields.IntegerField')()),
        ))
        db.send_create_signal(u'trx_app', ['ChainToQuestion'])

        # Adding model 'QuestionProject'
        db.create_table(u'trx_app_questionproject', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('project_name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=50)),
        ))
        db.send_create_signal(u'trx_app', ['QuestionProject'])

        # Adding model 'QuestionProjectToChain'
        db.create_table(u'trx_app_questionprojecttochain', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('question_set', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.QuestionProject'])),
            ('question_chain', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.QuestionChain'])),
            ('stack_index', self.gf('django.db.models.fields.IntegerField')()),
        ))
        db.send_create_signal(u'trx_app', ['QuestionProjectToChain'])

        # Adding model 'QuestionChain'
        db.create_table(u'trx_app_questionchain', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('chain_name', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal(u'trx_app', ['QuestionChain'])

        # Adding model 'JSONFiles'
        db.create_table(u'trx_app_jsonfiles', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('file_name', self.gf('django.db.models.fields.CharField')(max_length=40)),
            ('file_text', self.gf('django.db.models.fields.TextField')()),
        ))
        db.send_create_signal(u'trx_app', ['JSONFiles'])

        # Adding model 'Option'
        db.create_table(u'trx_app_option', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('question', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Question'])),
            ('branch', self.gf('django.db.models.fields.related.ForeignKey')(default=None, to=orm['trx_app.QuestionChain'], null=True, blank=True)),
            ('text', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('translation', self.gf('django.db.models.fields.CharField')(max_length=50, null=True)),
            ('display_text', self.gf('django.db.models.fields.CharField')(max_length=30, null=True)),
            ('highlight', self.gf('django.db.models.fields.CharField')(default='n', max_length=2, null=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Option'])

        # Adding model 'Doctor_Config'
        db.create_table(u'trx_app_doctor_config', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('doctor_name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=30)),
        ))
        db.send_create_signal(u'trx_app', ['Doctor_Config'])

        # Adding model 'Question'
        db.create_table(u'trx_app_question', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('question_type', self.gf('django.db.models.fields.CharField')(max_length=5)),
            ('question_text', self.gf('django.db.models.fields.CharField')(max_length=300)),
            ('translation_text', self.gf('django.db.models.fields.CharField')(max_length=300, null=True)),
            ('display_text', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('display_group', self.gf('django.db.models.fields.CharField')(max_length=30)),
        ))
        db.send_create_signal(u'trx_app', ['Question'])


    def backwards(self, orm):
        # Deleting model 'SurgeryType_Config'
        db.delete_table(u'trx_app_surgerytype_config')

        # Deleting model 'ChainToQuestion'
        db.delete_table(u'trx_app_chaintoquestion')

        # Deleting model 'QuestionProject'
        db.delete_table(u'trx_app_questionproject')

        # Deleting model 'QuestionProjectToChain'
        db.delete_table(u'trx_app_questionprojecttochain')

        # Deleting model 'QuestionChain'
        db.delete_table(u'trx_app_questionchain')

        # Deleting model 'JSONFiles'
        db.delete_table(u'trx_app_jsonfiles')

        # Deleting model 'Option'
        db.delete_table(u'trx_app_option')

        # Deleting model 'Doctor_Config'
        db.delete_table(u'trx_app_doctor_config')

        # Deleting model 'Question'
        db.delete_table(u'trx_app_question')


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
        u'trx_app.chaintoquestion': {
            'Meta': {'object_name': 'ChainToQuestion'},
            'chain': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.QuestionChain']"}),
            'chain_index': ('django.db.models.fields.IntegerField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Question']"})
        },
        u'trx_app.doctor': {
            'Meta': {'ordering': "['lastName', 'firstName']", 'unique_together': "(('firstName', 'middleName', 'lastName'),)", 'object_name': 'Doctor'},
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'middleName': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'})
        },
        u'trx_app.doctor_config': {
            'Meta': {'object_name': 'Doctor_Config'},
            'doctor_name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
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
        u'trx_app.jsonfiles': {
            'Meta': {'object_name': 'JSONFiles'},
            'file_name': ('django.db.models.fields.CharField', [], {'max_length': '40'}),
            'file_text': ('django.db.models.fields.TextField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
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
        u'trx_app.option': {
            'Meta': {'object_name': 'Option'},
            'branch': ('django.db.models.fields.related.ForeignKey', [], {'default': 'None', 'to': u"orm['trx_app.QuestionChain']", 'null': 'True', 'blank': 'True'}),
            'display_text': ('django.db.models.fields.CharField', [], {'max_length': '30', 'null': 'True'}),
            'highlight': ('django.db.models.fields.CharField', [], {'default': "'n'", 'max_length': '2', 'null': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.Question']"}),
            'text': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'translation': ('django.db.models.fields.CharField', [], {'max_length': '50', 'null': 'True'})
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
        u'trx_app.question': {
            'Meta': {'object_name': 'Question'},
            'display_group': ('django.db.models.fields.CharField', [], {'max_length': '30'}),
            'display_text': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question_text': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'question_type': ('django.db.models.fields.CharField', [], {'max_length': '5'}),
            'translation_text': ('django.db.models.fields.CharField', [], {'max_length': '300', 'null': 'True'})
        },
        u'trx_app.questionchain': {
            'Meta': {'object_name': 'QuestionChain'},
            'chain_name': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        },
        u'trx_app.questionproject': {
            'Meta': {'object_name': 'QuestionProject'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'project_name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '50'})
        },
        u'trx_app.questionprojecttochain': {
            'Meta': {'object_name': 'QuestionProjectToChain'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question_chain': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.QuestionChain']"}),
            'question_set': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['trx_app.QuestionProject']"}),
            'stack_index': ('django.db.models.fields.IntegerField', [], {})
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
        u'trx_app.surgerytype_config': {
            'Meta': {'object_name': 'SurgeryType_Config'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'surgery_name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'})
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