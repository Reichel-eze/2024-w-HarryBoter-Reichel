class Bot {
  var property cargaElectrica
  var property tipoAceite 
  var property aceitoPuro = true  // si tiene aceite puro o aceite sucio.
  const hechizosAprendidos = []

  method disminuirCargaEn(cantidad) {cargaElectrica -= cantidad}
  method anularCarga() {cargaElectrica = 0}

  method cantHechizosAprendidos() = hechizosAprendidos.size()

  method cambiarAceite(tipo) {tipoAceite = tipo}

  //method asistirAMateria() = self.aprenderHechizo()

  method aprenderHechizo(hechizo) = hechizosAprendidos.add(hechizo)

  method lanzarHechizo(hechizo, individuoHechizado) {
    self.conoceElHechizo(hechizo)
    self.estaActivo()   
    self.tieneLosRequisitosDel(hechizo)
    individuoHechizado.sufrirConsecunciasDeHechizo(hechizo)
  }

  method conoceElHechizo(hechizo) = hechizosAprendidos.contains(hechizo)

  method estaActivo() = cargaElectrica > 0 // Cuando un bot queda con carga eléctrica 0 se considera inactivo.

  method tieneLosRequisitosDel(hechizo) = hechizo.requisitos(self)

  method sufrirConsecunciasDeHechizo(hechizo) {
    //if(self.tieneProteccion)
    //  throw new DomainException(message = "El bot cuenta con una proteccion que atenua los efectos")
    //else 
    //  hechizo.consecuencias(self)
  }


}

class SombreroSeleccionar inherits Bot {
  /*
  Hay ciertos elementos, aparentemente inertes 
  pero que en realidad son bots, como las escobas, 
  las varitas, la snitch del quidditch, 
  el sombrero seleccionador y otros. 
  */

  override method cambiarAceite(tipo) {}  // El sombrero bot seleccionador es inmune a los intentos de cambiarle el aceite.




}

class BotEstudiante inherits Bot {
  var casa  // puede ser Gryffindor, Slytherin, Ravenclaw y Hufflepuff.
  
  method perteneceAUnaCasaPeligrosa() = casa.esPeligrosa()

  method esExperimentado() = self.cantHechizosAprendidos() > 3 and self.cargaElectrica() > 50

}

class Profesor inherits BotEstudiante {
  const materiasDictadas = []

  method cantMateriasDictadas() = materiasDictadas.size()

  override method esExperimentado() = super() and self.cantMateriasDictadas() >= 2

  //method puedeDefenderseDeLosEfectosDeLosHechizos() = true  
  
  override method disminuirCargaEn(cantidad) {}         // Cualquier intento de disminuir su carga electrica es inofensivo.
  override method anularCarga() {cargaElectrica /= 2}   // Pero en caso que de que se le intente anularla totalmente, queda en la mitad.

}

class Casa {
  const integrantes = []
  //var esPeligrosa
  
  method perteneceALaCasa(individuo) = integrantes.contains(individuo) 

  method esPeligrosa() = self.cantidadIntegrantesConAceiteSucio() > self.cantidadIntegrantesConAceiteLimpio()

  method cantidadIntegrantesConAceiteSucio() = integrantes.count({integrante => !integrante.aceitePuro()})
  method cantidadIntegrantesConAceiteLimpio() = integrantes.count({integrante => integrante.aceitePuro()}) 

}

object gryffindor inherits Casa {
  override method esPeligrosa() = false
}

object slytherin inherits Casa {
  override method esPeligrosa() = true
}

object ravenclaw inherits Casa {}

object hufflepuff inherits Casa {}


//const gryffindorV2 = new Casa (esPeligrosa = false)
//const slytherinV2 = new Casa (esPeligrosa = true)
//const ravenclawV2 = new Casa ()
//const hufflepuff = new Casa ()

// HECHIZOS

object inmobilus {
  method consecuencias(individuo) = individuo.dismunirCargaEn(50)
  method requisitos(individuo) = true  // no hay requisitos adicionales para lanzarlo
}

object sectumSempra {
  method consecuencias(individuo) = if(individuo.tipoAceite()) individuo.aceitoPuro(false) 
  method requisitos(hechizero) = hechizero.esExperimentado()
}

object avadakedabra {
  method consecuencias(individuo) = individuo.anularCarga()
  method requisitos(hechizero) = !hechizero.aceitePuro() or hechizero.perteneceAUnaCasaPeligrosa()
}

class HechizoComun {
  const cantidadADisminuir
  
  method consecuencias(individuo) = individuo.dismunirCargaEn(cantidadADisminuir)
  method requisitos(hechizero) = hechizero.cargaElectrica() > cantidadADisminuir
}

// Inventar un nuevo hechizo.