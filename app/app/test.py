from django.test import SimpleTestCase
from app import calc


class CalcTest(SimpleTestCase):
    """ Sample Calc Test """

    def test_add_num(self):
        """ Testing the calc method"""
        res = calc.add(5, 3)
        self.assertEqual(res, 8)
