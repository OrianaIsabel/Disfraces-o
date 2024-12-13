class Fiesta {
  const property lugar
  const property fecha = new Date()
  const property invitados = []

  method esBodrio() = invitados.all({invitado => !(invitado.estaConforme(self))})

  method disfrazesPresentes() = invitados.map({invitado => invitado.disfraz()}) 

  method mejorDisfraz() = self.disfrazesPresentes().max({disfraz => disfraz.puntos(self)})

  method estanPresentes(personas) = personas.all({persona => persona.esInvitado(self)})

  method algunDisconforme(personas) = personas.any({persona => !(persona.estaConforme(self))})

  method necesitanCambiar(persona1, persona2) = self.estanPresentes([persona1, persona2]) && self.algunDisconforme([persona1, persona2])

  method duoParaCambiar(persona1, persona2) = persona1.cambiariaCon(persona2, self) && persona2.cambiariaCon(persona1, self)

  method puedenCambiar(persona1, persona2) = self.necesitanCambiar(persona1, persona2) && self.duoParaCambiar(persona1, persona2)

  method dejaEntrar(persona) = persona.disfraz().esDisfraz() && !(invitados.contains(persona))

  method agregarInvitado(persona) {
    if(self.dejaEntrar(persona))
      invitados.add(persona)
  }
}

class Invitado {
  var property disfraz = ninguno
  const property edad
  var property personalidad
  const property criterio

  method esSexy() = personalidad.loHaceSexy(self)

  method cambiarPersonalidad() {
    personalidad.cambiarEstado()
  }

  method estaConforme(fiesta) = if(disfraz.esDisfraz()) self.loConformaria(disfraz, fiesta) else {throw new DomainException()}

  method loConformaria(otroDisfraz, fiesta) = otroDisfraz.puntos(self, fiesta) > 10 && criterio.aceptaPara(self, otroDisfraz, fiesta)

  method esInvitado(fiesta) = fiesta.invitados().contains(self)

  method combiariaCon(otro, fiesta) = self.loConformaria(otro.disfraz(), fiesta)
}

object alegre {
  method loHaceSexy(persona) = false

  method cambiarEstado() {}

  method opuesto() = taciturno
}

object taciturno {
  method loHaceSexy(persona) = persona.edad() < 30

  method cambiarEstado() {}

  method opuesto() = alegre
}

class Cambiante {
  var property estado

  method loHaceSexy(persona) = estado.loHaceSexy(persona)

  method cambiarEstado() {
    estado = estado.opuesto()
  }
}

object caprichoso {
  method aceptaPara(persona, disfraz, fiesta) = disfraz.nombre().size().even()
}

object pretensioso {
  method consideraReciente(disfraz, fiesta) = disfraz.confeccion().between(fiesta.fecha().minusDays(30), fiesta.fecha())

  method aceptaPara(persona, disfraz, fiesta) = self.consideraReciente(disfraz, fiesta)
}

class Numerologo {
  const cifra

  method aceptaPara(persona, disfraz, fiesta) = disfraz.puntos(persona, fiesta) == cifra
}

class Disfraz {
  const property nombre
  const property confeccion = new Date()
  const property caracteristicas = []
  const property gracia
  const property compra = new Date()
  var property dueno

  method esDisfraz() = true

  method puntos(fiesta) = caracteristicas.sum({x => x.puntos(self, fiesta)})
}

object ninguno {
  method esDisfraz() = false
}

object gracioso {
  method puntos(disfraz, fiesta) = if(disfraz.dueno().edad() > 50) disfraz.gracia() * 3 else disfraz.gracia()
}

object tobaras {
  method nuevoPara(disfraz, fiesta) = disfraz.compra().between(fiesta.fecha().minusDays(2), fiesta.fecha())

  method puntos(disfraz, fiesta) = if(self.nuevoPara(disfraz, fiesta)) 3 else 5
}

class Careta {
  const property personaje

  method puntos(disfraz, fiesta) = personaje.valor() 
}

object mickeyMouse {
  method valor() = 8
}

object osoCarolina {
  method valor() = 6
}

object sexy {
  method puntos(disfraz, fiesta) = if(disfraz.dueno().esSexy()) 15 else 2
}

object inolvidable inherits Fiesta(lugar = "moron") {
  override method dejaEntrar(persona) = super(persona) && persona.esSexy() && persona.estaConforme(self)
}