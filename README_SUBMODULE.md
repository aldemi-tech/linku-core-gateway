# Payment Gateway Functions - Domain Module

Este repositorio contiene las **funciones de dominio de pagos** para el ecosistema Aldemi Functions. Está diseñado para funcionar como **submódulo git** dentro del monorepo principal.

## 🏗️ Arquitectura

### Como Submódulo
```
aldemi-functions-core/          # Repo principal  
└── packages/
    └── payment/               # Este repo como submódulo
        ├── src/
        │   ├── index.ts      # Exporta funciones con prefijo "payment"
        │   ├── providers/
        │   ├── types/
        │   └── utils/
        └── .github/workflows/ # CI/CD independiente
```

### Como Repo Independiente
```
linku-payment-gateway/         # Este repo
├── src/                      # Funciones de payment
├── .github/workflows/        # CI/CD de payment  
└── docs/                    # Documentación específica
```

## 🚀 Funciones Exportadas

Todas las funciones se exportan con el prefijo `payment` para evitar conflictos:

| Función Original | Función Exportada | Descripción |
|------------------|-------------------|-------------|
| `tokenizeCardDirect` | `paymentTokenizeCardDirect` | Tokenización directa de tarjetas |
| `createTokenizationSession` | `paymentCreateTokenizationSession` | Sesión de tokenización con redirect |
| `completeTokenization` | `paymentCompleteTokenization` | Completar tokenización desde callback |
| `processPayment` | `paymentProcessPayment` | Procesar pago con tarjeta tokenizada |
| `refundPayment` | `paymentRefundPayment` | Reembolso total o parcial |
| `webhook` | `paymentWebhook` | Webhook unificado para providers |
| `getAvailableProviders` | `paymentGetAvailableProviders` | Listar providers disponibles |
| `getExecutionLocation` | `paymentGetExecutionLocation` | Info de ubicación de ejecución |

## 🔄 Desarrollo

### Desarrollo Independiente
```bash
# Clonar repo independiente
git clone https://github.com/aldemi-tech/linku-payment-gateway.git
cd linku-payment-gateway

# Instalar dependencias
npm install

# Desarrollo local
npm run serve

# Tests
npm test

# Deploy independiente
npm run build
firebase deploy --only functions:payment*
```

### Desarrollo en Monorepo
```bash
# En el repo core
cd packages/payment

# Hacer cambios...
git add .
git commit -m "feat: nueva funcionalidad payment"
git push origin main

# El core repo detectará el cambio automáticamente
cd ../..
git add packages/payment
git commit -m "update: payment domain"
```

## 📦 CI/CD

### CI/CD Independiente
- ✅ **Testing:** Se ejecuta en cada PR y push  
- ✅ **Deploy automático:** Solo funciones con prefijo `payment`
- ✅ **Deploy selectivo:** Solo despliega si cambió este dominio

### CI/CD en Monorepo
- 🎯 **Deploy inteligente:** Solo despliega si este dominio cambió
- 🔄 **Testing integrado:** Tests de todo el monorepo
- 📊 **Deployment unified:** Un solo deploy con todos los dominios

## 🛠️ Comandos Útiles

### En Repo Independiente
```bash
# Testing local
npm test
npm run serve

# Deploy manual
firebase deploy --only functions:payment*

# Build 
npm run build
```

### Como Submódulo en Core
```bash
# Actualizar submódulo (desde core repo)
git submodule update --remote packages/payment

# Deploy solo payment (desde core repo)
npm run deploy:payment

# Build solo payment (desde core repo)
npm run build:payment
```

## 🔧 Configuración

### Variables de Entorno
El dominio payment usa estas configuraciones:

```bash
# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Transbank (opcional - tiene credenciales de prueba automáticas)  
TRANSBANK_API_KEY=your_test_key
TRANSBANK_COMMERCE_CODE=your_commerce_code

# MercadoPago
MERCADOPAGO_ACCESS_TOKEN=TEST-...
```

### Firebase Config (Alternativa)
```bash
firebase functions:config:set stripe.secret_key="sk_test_..."
firebase functions:config:set transbank.api_key="your_key"
firebase functions:config:set mercadopago.access_token="TEST-..."
```

## 🧪 Testing

### Local Testing
```bash
# Tests unitarios
npm test

# Tests de integración con emulador
npm run serve
curl http://localhost:5001/project-id/us-central1/paymentGetAvailableProviders
```

### Credenciales de Prueba
- ✅ **Transbank:** Funciona automáticamente sin configuración
- ⚠️ **Stripe:** Requiere claves de prueba de tu cuenta  
- ⚠️ **MercadoPago:** Requiere access token de prueba

Ver [TEST_CREDENTIALS.md](./docs/TEST_CREDENTIALS.md) para detalles.

## 📊 Monitoring

### Logs por Función
```bash
# Ver logs de funciones payment
firebase functions:log --only paymentProcessPayment
firebase functions:log --only paymentWebhook

# Ver logs en tiempo real
firebase functions:log --follow
```

### Métricas
- **Invocaciones:** Por función individual
- **Errores:** Separados por dominio payment
- **Latencia:** Medida por función específica

## 🚨 Troubleshooting

### Problemas Comunes

#### Error: "Function not found"
```bash
# Verificar que las funciones tengan el prefijo correcto
firebase functions:list | grep payment
```

#### Error: "Provider not found"
```bash
# Verificar providers disponibles
curl https://project-id.cloudfunctions.net/paymentGetAvailableProviders
```

#### Error: "Configuration missing"
```bash
# Verificar configuración
firebase functions:config:get
```

### Debug Local
```bash
# Iniciar con debug
firebase emulators:start --only functions --inspect-functions

# Ver logs detallados
firebase functions:log --follow --only paymentProcessPayment
```

## 🔗 Enlaces

- **Repo Principal:** [aldemi-functions-core](https://github.com/aldemi-tech/aldemi-functions-core)
- **Documentación API:** [API_DOCUMENTATION.md](./docs/README_IMPLEMENTATION.md)  
- **Arquitectura:** [MONOREPO_ARCHITECTURE.md](./docs/MONOREPO_ARCHITECTURE.md)
- **Testing:** [TESTING_LAZY_INITIALIZATION.md](./docs/TESTING_LAZY_INITIALIZATION.md)

---

**Este proyecto funciona tanto independientemente como submódulo del monorepo Aldemi Functions Core** 🚀