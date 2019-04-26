extends "res://addons/gut/test.gd"

func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_assert_eq_number_not_equal():
	assert_eq(1, 2, "Should fail.  1 != 2")

func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")

func test_assert_true_with_false():
	assert_true(false, "Should fail")

func test_something_else():
	assert_true(false, "didn't work")
	
class TestFeatureA:
	extends 'res://addons/gut/test.gd'

	var Obj = load('res://Scripts/Character.gd')
	var _obj = null

	func before_each():
		_obj = Obj.new()

	func test_something():
		assert_true(_obj._ready(), 'Should be cool.')

class TestFeatureB:
	extends 'res://addons/gut/test.gd'

	var Obj = load('res://scripts/object.gd')
	var _obj = null

	func before_each():
		_obj = Obj.new()

	func test_foobar():
		assert_eq(_obj.foo(), 'bar', 'Foo should return bar')