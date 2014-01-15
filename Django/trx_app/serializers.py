from rest_framework import serializers
from trx_app import models

# TODO: should probably be more strict with the required tag
class DynamicFieldsModelSerializer(serializers.ModelSerializer):
    """
    A ModelSerializer that takes an additional `fields` argument that
    controls which fields should be displayed.
    """

    def __init__(self, *args, **kwargs):
        # Don't pass the 'fields' arg up to the superclass
        fields = kwargs.pop('fields', None)

        # Instantiate the superclass normally
        super(DynamicFieldsModelSerializer, self).__init__(*args, **kwargs)

        if fields:
            # Drop any fields that are not specified in the `fields` argument.
            allowed = set(fields)
            existing = set(self.fields.keys())
            for field_name in existing - allowed:
                self.fields.pop(field_name)
 
class PatientSerializer(DynamicFieldsModelSerializer):

    class Meta:
        model = models.Patient

class AudioSerializer(DynamicFieldsModelSerializer):

    class Meta:
        model = models.Audio

class ImageSerializer(DynamicFieldsModelSerializer):

    class Meta:
        model = models.Image

class OrderSerializer(DynamicFieldsModelSerializer):

    class Meta:
        model = models.Order

class ConfigSerializer(DynamicFieldsModelSerializer):

    class Meta:
        model = models.JSONFiles

