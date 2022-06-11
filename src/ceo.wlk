import wollok.game.*
    
const velocidad = 250

object bitcoin {
	var position = game.at(60,1)
	method position() = position
	method image () = "bitcoin.png"	
	
	method chocar() {
		bitcoin_counter.add_btc()
		bank.more_hard()
	}
	
	method iniciar() {
		position = game.at(60,1)
		game.onTick(50, "movingBtc", {self.mover()})
	}
	
	method terminar() {
		game.removeTickEvent("movingBtc")
	}
	
	method mover() {
		if (position.x() == 0) {
			position = game.at(90, 1)
		}
		position = position.left(1)
	}
}

object bitcoin_counter {
	var bitcoins = 0
	method text() = "BITCOINS: "+bitcoins.toString()
	method position() = game.at(50, 90)
	
	method add_btc () {
		bitcoins+=1
	}
	
	method reset () {
		bitcoins = 0
	}
}

object bank {
	var position = game.at(90, 1)
	var vel = 50
 
	method position() = position
	method image () = "bank.png"
	
	method iniciar() {
		position = game.at(90,1)
		game.onTick(vel, "movingbank", {self.mover()})
	}

	method more_hard() {
		vel -= 10;
		game.removeTickEvent("movingbank")
		game.onTick(vel, "movingbank", {self.mover()})
	}

	method mover() {
		if (position.x() == 0) {
			position = game.at(90, 1)
		}
		position = position.left(1)
	}
		
	method terminar() {
		game.removeTickEvent("movingbank")
	}	
	
	method subir_Vel() {
		vel += 10
	}
	
	method chocar() {
		juego.terminar()
	}

}

object ceo {
	var x = 0
	var vivo = true
	var position = game.at(10,suelo.position().y())
	var image = "athlete_idle.png"
	const image_jumping = "ceo_jump_0.png"    method image() = image
	method position() = position
	
	method animation () {
		if (x==6) {
			x = 0
		}
		image = "ceo_run_"+x+".png"
		x+=1
	}
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			image = image_jumping
		}
	}
	
	method subir(){
		game.removeTickEvent("running")
		position = position.up(10)
		game.schedule(700, {position = position.down(10)})
		self.running()
	}
	
	method morir(){
		game.say(self,"¡Auch!")
		game.removeTickEvent("running")
		vivo = false
	}
	
	method running() {
		game.onTick(40, "running", {=> self.animation()})
		vivo = true
	}
	
	method iniciar() {
		self.running()
	}
	method estaVivo() {
		return vivo
	}
}

object juego{

		method configurar(){
		game.width(100)
		game.height(100)
		game.title("ceo Game")		game.addVisual(ceo)
		game.addVisual(bank)
		game.addVisual(bitcoin)
		game.addVisual(bitcoin_counter)
		game.boardGround("game_background.jpg")
		game.cellSize(5)
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(ceo,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		ceo.iniciar()
		bank.iniciar()
		bitcoin.iniciar()
	}
	
	method jugar(){
		if (ceo.estaVivo()) {
			ceo.saltar()
		}
			
	else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		ceo.morir()
		bank.terminar()
		bitcoin.terminar()
		bitcoin_counter.reset()
	}
	
}
object gameOver {
	method position() = game.center()
	method text() = "GAME OVER - \n PRESS START TO RUN AGAIN"
}


object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


