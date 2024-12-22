import Superman

class Base {
	func function(_ b: Bool, i: Int, double d: Double) {
		print("Base: (\(b), \(i), \(d))")
	}
}

class Child: Base {
	@Super
	override func function(_ b: Bool, i: Int, double d: Double) {
		#super
		#super()
		#super(true)
		#super(false, i: 3)
		#super(true, i: 5, double: 4.4)
		#super(i: 7)
		#super(i: 9, double: 6.6)
		#super(double: 8.8)
	}
}

func main() {
	let child = Child()
	child.function(false, i: 1, double: 2.2)
}
main()
