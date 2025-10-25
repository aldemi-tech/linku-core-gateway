# Linku Core Orchestrator

Sistema orquestador central que coordina todos los microservicios del ecosistema Linku.

## Arquitectura

Este repositorio funciona como el **core** de una arquitectura de microservicios donde cada dominio tiene su propio repositorio git independiente:

- **linku-core** (este repo): Orquestrador principal y registry de servicios
- **linku-payment-functions**: Funciones de gateway de pagos
- **linku-meet-functions**: Funciones de Google Meet y calendario

## Estructura del Proyecto

```
linku-core/
├── src/
│   └── index.ts          # Orquestrador principal
├── docs/                 # Documentación general
├── firebase.json         # Configuración de Firebase
└── README.md            # Este archivo
```

## Funciones Disponibles

### Core Functions

- `healthCheck`: Verifica el estado del orquestrador
- `getAvailableServices`: Lista todos los servicios disponibles

### Servicios Conectados

#### Payment Domain
- Repository: `linku-payment-functions`
- Functions: `paymentTokenizeCardDirect`, `paymentProcessPayment`, etc.

#### Meet Domain  
- Repository: `linku-meet-functions`
- Functions: `meetCreateMeeting`, `meetListMeetings`, etc.

## Instalación

1. Clona este repositorio:
   ```bash
   git clone <repo-url>
   cd linku-core
   ```

2. Instala dependencias:
   ```bash
   npm install
   ```

3. Configura Firebase:
   ```bash
   firebase login
   firebase use --add
   ```

## Desarrollo

### Tests
```bash
npm test
```

### Build
```bash
npm run build
```

### Deploy Core
```bash
npm run deploy
```

## Microservicios

Para configurar los microservicios por separado, consulta los repositorios individuales:

- [linku-payment-functions](../linku-repos/linku-payment-functions)
- [linku-meet-functions](../linku-repos/linku-meet-functions)

## Contribución

Cada dominio tiene su propio ciclo de desarrollo independiente. Ver documentación específica en cada repositorio de microservicio.

## Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.