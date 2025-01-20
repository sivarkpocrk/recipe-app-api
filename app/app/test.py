from django.test import SimpleTestCase
from app import calc


class CalcTest(SimpleTestCase):

    def test_add_num(self):
        res = calc.add(5, 3)
        self.assertEqual(res, 8)
