# ArquitecturaSFV-P1

# Evaluación Práctica - Ingeniería de Software V

## Información del Estudiante

- **Nombre:** Óscar Andrés Gómez Lozano
- **Código:** A00394142
- **Fecha:** 06/08/2025

## Resumen de la Solución

Cree un Dockerfile que me permitiera colocar variables de entorno y un script de automatización que ejecutara un comando dentro del contenedor. El objetivo es demostrar el uso de Docker para la creación de entornos aislados y la automatización de tareas.

## Dockerfile

En el caso del Dockerfile, decidí utilizar una imagen base de node ya que era una aplicación de express sencilla que no requería de una imagen más pesada o específica.

## Script de Automatización

[Describe cómo funciona tu script y las funcionalidades implementadas]

Esto indica que quiero usar bash

# !/bin/sh

El nombre que tendrá el contenedor

```Bash
container_name="taller_docker"
```

Aquí mira que esté usando docker al verificar con command -v si existe dentro el system path, >/dev/null 2>&1 redirige la salida estándar y de error a /dev/null para que no se muestre nada en la terminal.

```Bash
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Please install Docker first."
  exit 1
fi
```

Esta simplemente compila la imagen de Docker usando el Dockerfile en el directorio actual.
sudo docker build -t "$container_name" .

Este comando va a matar el contenedor una vez se oprima ctrl-c

# This is a small trick to kill the container

```Bash
trap 'echo "Stopping container..."; sudo docker stop "$container_name"; sudo docker rm "$container_name"; exit' INT
```

Este comando va a correr el contenedor con el puerto 8080, la variable de entorno PORT y NODE_ENV, y lo ejecutará en segundo plano.

```Bash
sudo docker run --name "$container_name" -p 8080:8080 -e PORT=8080 -e NODE_ENV=production -d "$container_name"
```

Este comando espera a que el contenedor esté listo para recibir peticiones. En este caso, espera a que el endpoint /health esté disponible.

```Bash
echo "Waiting for service to be available at <http://localhost:8080/health>..."
until curl -sf <http://localhost:8080/health> >/dev/null; do
  sleep 1
done
```

Cuando el servicio responde, imprime "Service is up! Making GET request:" y luego realiza una petición GET a `<http://localhost:8080/health>` mostrando la respuesta.

```Bash
echo "Service is up! Making GET request:"
curl <http://localhost:8080/health>
```

Después, espera a que el contenedor Docker con el nombre almacenado en la variable `$container_name` termine de ejecutarse.  

- El bucle `while sudo docker ps | grep -q "$container_name"; do sleep 1; done` revisa cada segundo si el contenedor sigue en ejecución y solo termina cuando el contenedor se detiene.

```Bash
while sudo docker ps | grep -q "$container_name"; do
  sleep 1
done
```

## Principios DevOps Aplicados

1. Automatización: El script de automatización permite la creación y gestión del contenedor Docker de manera sencilla, reduciendo la intervención manual.
2. Containerizción: Ya que se utiliza Docker para crear un entorno aislado que contiene todas las dependencias necesarias para ejecutar la aplicación.
3. Estructura de Microservicios: Aunque es una aplicación sencilla, el uso de Docker permite escalar y dividir la aplicación en microservicios en el futuro si es necesario.

## Captura de Pantalla

## Mejoras Futuras

[Describe al menos 3 mejoras que podrían implementarse en el futuro]

- Manejo de errores más robusto en el script de automatización.
- Implementación de pruebas automatizadas para verificar el estado del contenedor y la aplicación.
- Integración con herramientas de monitoreo para supervisar el estado del contenedor y la aplicación

[Instrucciones paso a paso para ejecutar tu solución]

Ejecutar el comando en la consola:

```Bash
bash run.sh
```
