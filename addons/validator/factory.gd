class_name ValidatorFactory


## Creates and returns a [Validator].
## Register any validators here using the Yandere Technique 
## (else if else if else if).
static func create_validator(r: Resource) -> Validator:
	if r is TraitSet:
		return TraitSetValidator.new(r as TraitSet)
	elif r is DialogCollection:
		return DialogCollectionValidator.new(r as DialogCollection)
	elif r is Item:
		return ItemValidator.new(r as Item)
	elif r is QuestData:
		return QuestDataValidator.new(r as QuestData)
	elif r is ShopOffer:
		return ShopOfferValidator.new(r as ShopOffer)
	else:
		push_error("Validator for given type not found!")
		return null
