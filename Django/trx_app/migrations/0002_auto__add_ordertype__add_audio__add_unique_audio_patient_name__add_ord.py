# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Removing unique constraint on 'Patient', fields ['firstName', 'middleName', 'lastName', 'birthday']
        db.delete_unique(u'trx_app_patient', ['firstName', 'middleName', 'lastName', 'birthday'])

        # Adding model 'OrderType'
        db.create_table(u'trx_app_ordertype', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=255)),
        ))
        db.send_create_signal(u'trx_app', ['OrderType'])

        # Adding model 'Audio'
        db.create_table(u'trx_app_audio', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('patient', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Patient'])),
            ('record', self.gf('django.db.models.fields.files.FileField')(max_length=100)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Audio'])

        # Adding unique constraint on 'Audio', fields ['patient', 'name']
        db.create_unique(u'trx_app_audio', ['patient_id', 'name'])

        # Adding model 'Order'
        db.create_table(u'trx_app_order', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('orderType', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.OrderType'])),
            ('patient', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Patient'])),
            ('text', self.gf('django.db.models.fields.TextField')()),
            ('index', self.gf('django.db.models.fields.IntegerField')()),
            ('isEditable', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Order'])

        # Adding unique constraint on 'Order', fields ['orderType', 'patient', 'index']
        db.create_unique(u'trx_app_order', ['orderType_id', 'patient_id', 'index'])

        # Adding model 'SurgeryType'
        db.create_table(u'trx_app_surgerytype', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=255)),
            ('isCurrent', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal(u'trx_app', ['SurgeryType'])

        # Adding model 'History'
        db.create_table(u'trx_app_history', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('patient', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Patient'])),
            ('key', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('value', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['History'])

        # Adding unique constraint on 'History', fields ['patient', 'key']
        db.create_unique(u'trx_app_history', ['patient_id', 'key'])

        # Adding model 'Video'
        db.create_table(u'trx_app_video', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('surgeryType', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.SurgeryType'])),
            ('videoType', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.VideoType'])),
            ('record', self.gf('django.db.models.fields.files.FileField')(max_length=100)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('isCurrent', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal(u'trx_app', ['Video'])

        # Adding model 'Recovery'
        db.create_table(u'trx_app_recovery', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('patient', self.gf('django.db.models.fields.related.OneToOneField')(to=orm['trx_app.Patient'], unique=True)),
            ('bloodPressure', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('heartRate', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('respiratory', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('sao2', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('o2via', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('ps', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Recovery'])

        # Adding model 'Location'
        db.create_table(u'trx_app_location', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('city', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('region', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('country', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('isCurrent', self.gf('django.db.models.fields.BooleanField')(default=True)),
        ))
        db.send_create_signal(u'trx_app', ['Location'])

        # Adding unique constraint on 'Location', fields ['city', 'region', 'country']
        db.create_unique(u'trx_app_location', ['city', 'region', 'country'])

        # Adding model 'PhysicalExam'
        db.create_table(u'trx_app_physicalexam', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('patient', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Patient'])),
            ('key', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('value', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['PhysicalExam'])

        # Adding unique constraint on 'PhysicalExam', fields ['patient', 'key']
        db.create_unique(u'trx_app_physicalexam', ['patient_id', 'key'])

        # Adding model 'OrderTemplate'
        db.create_table(u'trx_app_ordertemplate', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('surgeryType', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.SurgeryType'])),
            ('orderType', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.OrderType'])),
            ('text', self.gf('django.db.models.fields.TextField')()),
            ('index', self.gf('django.db.models.fields.IntegerField')()),
            ('isEditable', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('isCurrent', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal(u'trx_app', ['OrderTemplate'])

        # Adding model 'VideoType'
        db.create_table(u'trx_app_videotype', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(unique=True, max_length=255)),
        ))
        db.send_create_signal(u'trx_app', ['VideoType'])

        # Adding model 'Image'
        db.create_table(u'trx_app_image', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('patient', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['trx_app.Patient'])),
            ('record', self.gf('django.db.models.fields.files.FileField')(max_length=100)),
            ('IsProfile', self.gf('django.db.models.fields.BooleanField')(default=True)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Image'])

        # Adding unique constraint on 'Image', fields ['patient', 'name']
        db.create_unique(u'trx_app_image', ['patient_id', 'name'])

        # Adding model 'LaboratoryData'
        db.create_table(u'trx_app_laboratorydata', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('patient', self.gf('django.db.models.fields.related.OneToOneField')(to=orm['trx_app.Patient'], unique=True)),
            ('trainTrack', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('e', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('honeycomb', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('invertedY', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('x', self.gf('django.db.models.fields.CharField')(max_length=255, null=True)),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['LaboratoryData'])

        # Adding field 'Patient.surgeryType'
        db.add_column(u'trx_app_patient', 'surgeryType',
                      self.gf('django.db.models.fields.related.ForeignKey')(default=1, to=orm['trx_app.SurgeryType']),
                      keep_default=False)

        # Adding field 'Patient.doctor'
        db.add_column(u'trx_app_patient', 'doctor',
                      self.gf('django.db.models.fields.related.ForeignKey')(default=1, to=orm['trx_app.Doctor']),
                      keep_default=False)

        # Adding field 'Patient.location'
        db.add_column(u'trx_app_patient', 'location',
                      self.gf('django.db.models.fields.related.ForeignKey')(default=1, to=orm['trx_app.Location']),
                      keep_default=False)

        # Adding field 'Patient.hasTimeout'
        db.add_column(u'trx_app_patient', 'hasTimeout',
                      self.gf('django.db.models.fields.BooleanField')(default=False),
                      keep_default=False)

        # Adding field 'Patient.isCurrent'
        db.add_column(u'trx_app_patient', 'isCurrent',
                      self.gf('django.db.models.fields.BooleanField')(default=True),
                      keep_default=False)


    def backwards(self, orm):
        # Removing unique constraint on 'Image', fields ['patient', 'name']
        db.delete_unique(u'trx_app_image', ['patient_id', 'name'])

        # Removing unique constraint on 'PhysicalExam', fields ['patient', 'key']
        db.delete_unique(u'trx_app_physicalexam', ['patient_id', 'key'])

        # Removing unique constraint on 'Location', fields ['city', 'region', 'country']
        db.delete_unique(u'trx_app_location', ['city', 'region', 'country'])

        # Removing unique constraint on 'History', fields ['patient', 'key']
        db.delete_unique(u'trx_app_history', ['patient_id', 'key'])

        # Removing unique constraint on 'Order', fields ['orderType', 'patient', 'index']
        db.delete_unique(u'trx_app_order', ['orderType_id', 'patient_id', 'index'])

        # Removing unique constraint on 'Audio', fields ['patient', 'name']
        db.delete_unique(u'trx_app_audio', ['patient_id', 'name'])

        # Deleting model 'OrderType'
        db.delete_table(u'trx_app_ordertype')

        # Deleting model 'Audio'
        db.delete_table(u'trx_app_audio')

        # Deleting model 'Order'
        db.delete_table(u'trx_app_order')

        # Deleting model 'SurgeryType'
        db.delete_table(u'trx_app_surgerytype')

        # Deleting model 'History'
        db.delete_table(u'trx_app_history')

        # Deleting model 'Video'
        db.delete_table(u'trx_app_video')

        # Deleting model 'Recovery'
        db.delete_table(u'trx_app_recovery')

        # Deleting model 'Location'
        db.delete_table(u'trx_app_location')

        # Deleting model 'PhysicalExam'
        db.delete_table(u'trx_app_physicalexam')

        # Deleting model 'OrderTemplate'
        db.delete_table(u'trx_app_ordertemplate')

        # Deleting model 'VideoType'
        db.delete_table(u'trx_app_videotype')

        # Deleting model 'Image'
        db.delete_table(u'trx_app_image')

        # Deleting model 'LaboratoryData'
        db.delete_table(u'trx_app_laboratorydata')

        # Deleting field 'Patient.surgeryType'
        db.delete_column(u'trx_app_patient', 'surgeryType_id')

        # Deleting field 'Patient.doctor'
        db.delete_column(u'trx_app_patient', 'doctor_id')

        # Deleting field 'Patient.location'
        db.delete_column(u'trx_app_patient', 'location_id')

        # Deleting field 'Patient.hasTimeout'
        db.delete_column(u'trx_app_patient', 'hasTimeout')

        # Deleting field 'Patient.isCurrent'
        db.delete_column(u'trx_app_patient', 'isCurrent')

        # Adding unique constraint on 'Patient', fields ['firstName', 'middleName', 'lastName', 'birthday']
        db.create_unique(u'trx_app_patient', ['firstName', 'middleName', 'lastName', 'birthday'])


    models = {
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
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
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
            'IsProfile': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'Meta': {'unique_together': "(('patient', 'name'),)", 'object_name': 'Image'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
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
        u'trx_app.location': {
            'Meta': {'unique_together': "(('city', 'region', 'country'),)", 'object_name': 'Location'},
            'city': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'country': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'region': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        u'trx_app.order': {
            'Meta': {'unique_together': "(('orderType', 'patient', 'index'),)", 'object_name': 'Order'},
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
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
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
            'Meta': {'unique_together': "(('patient', 'key'),)", 'object_name': 'PhysicalExam'},
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
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        },
        u'trx_app.video': {
            'Meta': {'object_name': 'Video'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
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