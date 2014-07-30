
import Foundation


//MARK: - Bool
let Yes = true
let No = false

//MARK: - Optionals
func | <T>(optional: T?, fallback: @auto_closure () -> T) -> T {
    return optional ? optional! : fallback()
}

