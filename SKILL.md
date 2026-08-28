---
name: prospeccion-linkedin-caudal
description: Flujo de prospección de Caudal por LinkedIn para conseguir conversaciones y respuestas de encuesta con empresas ecuatorianas que venden a crédito (validación de mercado, COM-02 pipeline y COM-07 cartas de intención). Usar esta habilidad siempre que Leonardo mencione la encuesta de validación, prospección, contactar empresas, mandar mensajes por LinkedIn, buscar gerentes financieros o jefes de cobranzas, armar la lista de empresas objetivo, o ejecutar envíos con Claude para Chrome — aunque no diga la palabra "prospección".
---

# Prospección por LinkedIn — Caudal

Flujo acordado con Leonardo (ago-2026) para conseguir que empresas que venden a crédito respondan la encuesta de validación y, sobre todo, acepten una conversación de 15 minutos. La encuesta es la excusa; el objetivo real es alimentar el pipeline comercial (COM-02) y las cartas de intención (COM-07).

## Principios innegociables

1. **La encuesta no es el titular.** El mensaje pide 15 minutos de conversación sobre cómo cobran hoy; el enlace a la encuesta es el plan B para quien no tenga tiempo. Nunca abrir con "llena mi encuesta".
2. **Leonardo aprueba cada envío.** Claude busca, redacta y prepara; Leonardo da el OK y hace clic. Nada se envía sin su clic. Esto aplica también en Claude para Chrome.
3. **Ritmo que no queme la cuenta:** máximo 10–15 solicitudes de conexión por día desde la cuenta personal de Leonardo. Mensaje completo solo después de que acepten la conexión. Nunca mandar tandas masivas de mensajes idénticos.
4. **Personalización real:** cada mensaje menciona algo específico de la empresa o del cargo de la persona. Prohibido plantilla genérica sin adaptar.
5. **No vender producto.** Caudal aún no tiene producto en producción. El tono es de investigación: "estamos estudiando cómo cobran las empresas en Ecuador". Sin promesas, sin métricas aspiracionales, sin precios.
6. **Vocabulario en español, sin anglicismos financieros** (según preferencias del proyecto Caudal).

## Perfil objetivo

- **Empresas:** ecuatorianas, ventas USD 2–50M, que venden a crédito B2B (30–90 días de plazo), cartera gestionada manualmente.
- **Sectores prioritarios:** distribuidoras de consumo masivo, farmacéuticas y distribuidoras médicas, materiales de construcción y ferretería mayorista, agroquímicos e insumos agrícolas, autopartes, importadoras de tecnología, seguridad industrial.
- **Cargos objetivo en LinkedIn:** Jefe de Crédito y Cobranzas, Gerente de Crédito, Gerente Financiero, Gerente Administrativo-Financiero, CFO, Contralor. En empresas más chicas: Gerente General.
- **Fuente de la lista:** estados financieros de la Superintendencia de Compañías → filtrar por sector + tamaño + cuentas por cobrar comerciales altas respecto a ventas (días de cartera = CxC ÷ ventas × 365). Prioridad a días de cartera ≥ 45.

## Flujo de trabajo (4 pasos, con OK explícito entre cada uno)

### Paso 1 — Lista objetivo
Construir o actualizar la tabla de empresas priorizadas: empresa, RUC, sector, ciudad, ventas, días de cartera estimados, cargo/persona a buscar en LinkedIn, estado del contacto. La lista vive en un archivo que Leonardo conserva (hoja de cálculo). Si no existe, crearla antes de tocar LinkedIn.

### Paso 2 — Plantillas de mensaje
Dos piezas, ambas aprobadas por Leonardo antes de usar:
- **Solicitud de conexión** (máx. 300 caracteres): amable, sin vender, identifica a Leonardo como fundador estudiando cobranza en Ecuador, pide conectar.
- **Mensaje de seguimiento** (al aceptar): agradece, pide 15 minutos de conversación sobre cómo gestionan la cobranza; si no hay tiempo, ofrece el enlace de la encuesta. Incluye el incentivo: al cerrar el levantamiento se les comparte un comparativo anónimo de días de cobro de su sector.
Las plantillas se adaptan por persona (nombre, empresa, sector). Ver `references/plantillas.md` para las versiones vigentes; si el archivo aún tiene marcadores pendientes, redactarlas y pedir aprobación.

### Paso 3 — Ejecución en Claude para Chrome
La navegación de LinkedIn ocurre en la extensión de Chrome, no en el chat. Instrucciones para dar a Claude en Chrome:
- Buscar a la persona por cargo + empresa según la lista del Paso 1.
- Verificar que el perfil corresponda (empresa correcta, Ecuador).
- Redactar la solicitud de conexión personalizada a partir de la plantilla.
- Mostrarla a Leonardo y esperar su clic. Nunca autoenviar.
- Al aceptar una conexión, preparar el mensaje de seguimiento y repetir el ciclo de aprobación.
- Máximo 10–15 solicitudes por sesión diaria.

### Paso 4 — Registro y seguimiento
Después de cada tanda, actualizar la lista con: fecha de contacto, estado (solicitud enviada / aceptada / mensaje enviado / respondió / conversación agendada / encuesta llenada / sin respuesta), y notas. A los 7 días sin respuesta tras el mensaje: un único recordatorio corto y amable; después, se deja. Quien acepta conversación pasa al pipeline COM-02.

## Errores a evitar (aprendidos)

- Encuesta fría por correo o mensaje masivo: 1–3% de respuesta, sesgada. No hacerlo.
- Buscar "gerente financiero Ecuador" a ciegas sin lista previa: puro ruido.
- Prometer producto, cifras de conciliación o precios: prohibido mientras no haya producto en producción.
- Usar el ángulo Shinkansen o cualquier claim descartado del proyecto.

## Decisiones cerradas

- **Alcance: solo crédito B2B** (deudor empresa con RUC). Confirmado por Leonardo el 27-ago-2026. El crédito directo a personas queda fuera de esta fase.

## Pendientes de decisión (actualizar cuando se cierren)

- Enlace definitivo de la encuesta y su duración (debe caber en 15 minutos hablados).
- Meta de respuestas: ¿10 conversaciones profundas o 50 encuestas rápidas?
