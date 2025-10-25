# Linku Microservices - Git Submodules Configuration

Este documento describe cómo configurar y trabajar con los repositorios separados.

## Estructura de Repositorios

- **linku-core**: Orquestrador principal (este repo)
- **linku-payment-functions**: Servicios de pago 
- **linku-meet-functions**: Servicios de Google Meet

## Configuración de Submodules (Opcional)

Si quieres trabajar con todos los repositorios desde un solo lugar, puedes usar git submodules:

```bash
# Desde el directorio del core
git submodule add ../linku-repos/linku-payment-functions services/payment
git submodule add ../linku-repos/linku-meet-functions services/meet

# Para clonar con submodules
git clone --recursive <core-repo-url>

# Para actualizar submodules
git submodule update --remote --recursive
```

## Desarrollo Independiente

Cada servicio puede desarrollarse independientemente:

### Payment Functions
```bash
cd /path/to/linku-payment-functions
npm install
npm run build
firebase deploy --only functions:paymentTokenizeCardDirect
```

### Meet Functions  
```bash
cd /path/to/linku-meet-functions
npm install
npm run build
firebase deploy --only functions:meetCreateMeeting
```

### Core Orchestrator
```bash
cd /path/to/linku-core
npm install
npm run deploy
```

## CI/CD Strategy

Cada repositorio puede tener su propio pipeline de CI/CD independiente:

1. **Core**: Deploy automático en cambios a main
2. **Payment**: Deploy específico de funciones de pago
3. **Meet**: Deploy específico de funciones de Meet

## Flujo de Trabajo Recomendado

1. Desarrollar cada servicio en su repositorio respectivo
2. Usar el core como registry y orquestrador
3. Deployar servicios independientemente según necesidad
4. Mantener documentación centralizada en el core