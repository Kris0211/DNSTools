@tool
class_name ShopOfferValidator extends Validator

var shop: ShopOffer

var _args: Array


func _init(_shop: ShopOffer):
	shop = _shop


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: # pseudo-destructor
			shop = null


func validate() -> bool:
	var res := true
	return res

