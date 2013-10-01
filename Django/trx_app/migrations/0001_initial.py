# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Doctor'
        db.create_table(u'trx_app_doctor', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('firstName', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('middleName', self.gf('django.db.models.fields.CharField')(max_length=255, null=True, blank=True)),
            ('lastName', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('isCurrent', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal(u'trx_app', ['Doctor'])

        # Adding unique constraint on 'Doctor', fields ['firstName', 'middleName', 'lastName']
        db.create_unique(u'trx_app_doctor', ['firstName', 'middleName', 'lastName'])

        # Adding model 'Patient'
        db.create_table(u'trx_app_patient', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('firstName', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('middleName', self.gf('django.db.models.fields.CharField')(max_length=255, blank=True)),
            ('lastName', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('birthday', self.gf('django.db.models.fields.DateField')()),
            ('lastModified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal(u'trx_app', ['Patient'])

        # Adding unique constraint on 'Patient', fields ['firstName', 'middleName', 'lastName', 'birthday']
        db.create_unique(u'trx_app_patient', ['firstName', 'middleName', 'lastName', 'birthday'])


    def backwards(self, orm):
        # Removing unique constraint on 'Patient', fields ['firstName', 'middleName', 'lastName', 'birthday']
        db.delete_unique(u'trx_app_patient', ['firstName', 'middleName', 'lastName', 'birthday'])

        # Removing unique constraint on 'Doctor', fields ['firstName', 'middleName', 'lastName']
        db.delete_unique(u'trx_app_doctor', ['firstName', 'middleName', 'lastName'])

        # Deleting model 'Doctor'
        db.delete_table(u'trx_app_doctor')

        # Deleting model 'Patient'
        db.delete_table(u'trx_app_patient')


    models = {
        u'trx_app.doctor': {
            'Meta': {'ordering': "['lastName', 'firstName']", 'unique_together': "(('firstName', 'middleName', 'lastName'),)", 'object_name': 'Doctor'},
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'isCurrent': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'middleName': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'})
        },
        u'trx_app.patient': {
            'Meta': {'ordering': "['lastName', 'firstName']", 'unique_together': "(('firstName', 'middleName', 'lastName', 'birthday'),)", 'object_name': 'Patient'},
            'birthday': ('django.db.models.fields.DateField', [], {}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'firstName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'lastModified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'lastName': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'middleName': ('django.db.models.fields.CharField', [], {'max_length': '255', 'blank': 'True'})
        }
    }

    complete_apps = ['trx_app']