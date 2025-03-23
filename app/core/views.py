"""
Core views for app.
"""
from django.http import HttpResponse  # noqa
from rest_framework.decorators import api_view
from rest_framework.response import Response

# Create your views here.


# def test(request):
#     return HttpResponse("Hello World")

@api_view(['GET'])
def health_check(request):
    """Return successful Response"""
    return Response({'healthy': True})
