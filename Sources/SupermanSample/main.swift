import Superman

class Base {
	func superFirst() {
		print("Base superFirst")
	}

	func superFirstArgs(_ b: Bool, i: Int, double d: Double) {
		print("Base superFirstArgs (\(b), \(i), \(d))")
	}

	func superLast() {
		print("Base superLast")
	}

	func superLastArgs(_ b: Bool, i: Int, double d: Double) {
		print("Base superLastArgs (\(b), \(i), \(d))")
	}
}

class Child: Base {
	@SuperFirst
	override func superFirst() {
		print("Child superFirst")
	}

	@SuperFirst
	override func superFirstArgs(_ b: Bool, i: Int, double d: Double) {
		print("Child superFirstArgs (\(b), \(i), \(d))")
	}

	@SuperLast
	override func superLast() {
		print("Child superLast")
	}

	@SuperLast
	override func superLastArgs(_ b: Bool, i: Int, double d: Double) {
		print("Child superLastArgs (\(b), \(i), \(d))")
	}
}

func main() {
	let child = Child()
	child.superFirst()
	child.superLast()
	child.superFirstArgs(true, i: 1, double: 0.1)
	child.superLastArgs(false, i: 0, double: 1.0)
}
main()
