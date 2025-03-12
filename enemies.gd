extends Node


const HEARTS = preload("res://assets/cards/hearts.tscn")
const SPADES = preload("res://assets/cards/spades.tscn")
const CLUBS = preload("res://assets/cards/clubs.tscn")
const DIAMONDS = preload("res://assets/cards/diamonds.tscn")

var rng = RandomNumberGenerator.new()

var mortage_to_pay = 850039
signal mortage_paid()

var enemy_increase_timer = 0
const ENEMY_TIMER_MAX = 120
var enemy_counter = 0
const ENEMY_MULTIPLIER = 0.5
const ENEMY_INITIAL_COUNT = 16

func _on_spawn_enemy_timeout():
	# every 240sek increase by 0.5 numer of enemies
	# initially: max 16
	# after 120s: max 24
	# after 240s: max 32..
	# show message about cards getting stronger after increases for 5sek
	enemy_increase_timer += 1
	if enemy_increase_timer == 10:
		%CardsMessage.hide()
	if enemy_increase_timer == ENEMY_TIMER_MAX:
		enemy_increase_timer = 0
		enemy_counter += 1
		%CardsMessage.show()
	
	if get_child_count() > ENEMY_INITIAL_COUNT + ENEMY_INITIAL_COUNT * ENEMY_MULTIPLIER * enemy_counter:
		return
	
	var enemy
	match rng.randi_range(0, 3):
		0:
			enemy = HEARTS.instantiate()
		1:
			enemy = SPADES.instantiate()
		2:
			enemy = CLUBS.instantiate()
		3:
			enemy = DIAMONDS.instantiate()
	
	# change to bounds <-2000, 2000>, <-2000, 2000>?
	%SpawnPosition.progress_ratio = rng.randf()
	#enemy.global_position = Vector2i(rng.randi_range(-2000, 2000), rng.randi_range(-2000, 2000))
	enemy.global_position = %SpawnPosition.global_position
	if enemy.global_position.x > 1950:
		enemy.global_position.x = 1950
	elif enemy.global_position.x < -1950:
		enemy.global_position.x = -1950
	
	if enemy.global_position.y > 1950:
		enemy.global_position.y = 1950
	elif enemy.global_position.y < -1950:
		enemy.global_position.y = -1950
	
	add_child(enemy)

func increase_kill_count():
	mortage_to_pay -= 1
	%Mortage.text = "Mortage pay: " + str(mortage_to_pay) + " PLN"
	if mortage_to_pay <= 0:
		mortage_paid.emit()

var rate_countdown = 0
const RATE_COUNDDOWN_FINISH = 30
func _on_interest_rate_timeout():
	rate_countdown += 1
	
	if rate_countdown > 5:
		%InterestRate.text = ""
	
	if rate_countdown > RATE_COUNDDOWN_FINISH / 2:
		%InterestRate.text = "New installment in: " + str(RATE_COUNDDOWN_FINISH - rate_countdown)
	if rate_countdown == RATE_COUNDDOWN_FINISH:
		rate_countdown = 0
		var interest = int(float(mortage_to_pay) * 0.05 / (30.0 * 12.0))
		mortage_to_pay += interest
		%Mortage.text = "Mortage pay: " + str(mortage_to_pay) + " PLN"
		%InterestRate.text = "+" + str(interest) + " PLN"
