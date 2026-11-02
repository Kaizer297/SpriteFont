# SpriteFont for Godot 4

[English](#english) | [Español](#español)

---

<a name="english"></a>
## English

A lightweight, high-performance custom `Control` node for **Godot 4** designed for Pixel Art games and dialogue systems. It renders text directly via `_draw()` without relying on `TextServer` overhead.

### Key Features
- **Automatic Proportional Cropping:** Scans alpha channels to automatically remove empty padding around characters.
- **Typewriter Effect:** Progressive character rendering with adjustable speeds, auto-start, and pauses.
- **Text Tag Effects:** Built-in parsing for `[shake]`, `[wave]`, `[speed=X]`, and `[pause=X]` tags.
- **Audio Integration:** Play custom sound effects per character with random pitch variation.
- **Word Wrapping & Alignments:** Line limits by word count, pixel-perfect letter/line spacing, and 2D alignment (Left, Center, Right, Top, Bottom).
- **Dynamic Inspector Language:** Switch UI labels and tooltips seamlessly between English and Spanish.

### BBCode Tags
- `[shake]Text[/shake]`: Shakes text characters in real time.
- `[wave]Text[/wave]`: Applies a smooth sine wave movement to characters.
- `[speed=0.1]Text[/speed]`: Adjusts typing speed dynamically for dramatic effect.
- `[pause=1.5]`: Pauses typewriter progression for a specified duration in seconds.

---

<a name="español"></a>
## Español

Un nodo `Control` ultraligero y de alto rendimiento para **Godot 4**, diseñado especialmente para juegos Pixel Art y sistemas de diálogo. Renderiza el texto directamente mediante `_draw()` eliminando el consumo innecesario del motor `TextServer`.

### Características Principales
- **Recorte Proporcional Automático:** Escanea el canal alfa para eliminar márgenes transparentes de cada letra a lo ancho y alto.
- **Efecto Máquina de Escribir:** Aparición progresiva de caracteres con velocidad personalizable, inicio automático y pausas.
- **Etiquetas de Efectos:** Soporte integrado para `[shake]`, `[wave]`, `[speed=X]` y `[pause=X]`.
- **Integración de Audio:** Reproduce sonidos por letra con variación aleatoria de tono (*Pitch Randomness*).
- **Límite de Palabras y Alineaciones:** Control de palabras por renglón, espaciado en píxeles y alineación bidireccional (Izquierda, Centro, Derecha, Arriba, Abajo).
- **Inspector Bilingüe:** Alterna la interfaz del Inspector y las descripciones flotantes entre Español e Inglés.

### Etiquetas de Texto
- `[shake]Texto[/shake]`: Hace temblar las letras en tiempo real.
- `[wave]Texto[/wave]`: Aplica un movimiento senoidal vertical suave.
- `[speed=0.1]Texto[/speed]`: Cambia la velocidad de aparición dinámicamente.
- `[pause=1.5]`: Pausa la máquina de escribir durante los segundos indicados.
