# Glue Framework - Modern Architecture Guide

## Overview

El framework Glue ha sido modernizado para reducir verbosidad y mejorar la experiencia del desarrollador. Esta guía muestra las nuevas características y cómo usarlas.

---

## 1. Vectores 2D Mejorados

### Antes (Verboso)
```haxe
player.position.set(Glue.width * 0.5, Glue.height - 80);
velocity.set(0, 0);
var dir = new GVector2D(0, -1);
```

### Ahora (Conciso)
```haxe
// Conversión implícita desde arrays
player.position = [Glue.width * 0.5, Glue.height - 80];

// Conversión implícita desde objetos anónimos
velocity = {x: 100, y: 50};

// Vectores predefinidos
var dir = GVector2D.up;      // (0, -1)
var origin = GVector2D.zero;  // (0, 0)
```

**Vectores Disponibles:**
- `GVector2D.zero` → (0, 0)
- `GVector2D.one` → (1, 1)
- `GVector2D.up` → (0, -1)
- `GVector2D.down` → (0, 1)
- `GVector2D.left` → (-1, 0)
- `GVector2D.right` → (1, 0)

---

## 2. API Fluida para Entidades

### Antes (Múltiples líneas)
```haxe
var player = new Player();
player.position.set(100, 200);
player.velocity.set(50, 0);
player.scale.set(2, 2);
player.anchor.set(0.5, 0.5);
player.alpha = 0.8;
add(player);
```

### Ahora (Encadenamiento)
```haxe
var player = add(new Player()
    .at(100, 200)
    .withVelocity(50, 0)
    .withScale(2, 2)
    .withAnchor(0.5, 0.5)
    .withAlpha(0.8));
```

**Métodos Disponibles:**
- `.at(x, y)` - Establecer posición
- `.withVelocity(vx, vy)` - Establecer velocidad
- `.withScale(sx, sy)` - Establecer escala
- `.withAnchor(ax, ay)` - Establecer ancla
- `.withRotation(rot)` - Establecer rotación
- `.withAlpha(a)` - Establecer transparencia

**Bonus:** `add()` ahora devuelve la entidad, permitiendo asignación directa.

---

## 3. Carga de Assets Simplificada

### Antes (Verboso)
```haxe
override public function preload()
{
    load.image("player", "assets/player.png");
    load.image("enemy", "assets/enemy.png");
    load.json("level", "assets/level.json");
    load.sound("music", "assets/music.mp3", "bgm");
}
```

### Ahora (Conciso)
```haxe
import glue.assets.Assets;

override public function preload()
{
    // Opción 1: Batch con ruta base
    Assets.batch()
        .fromPath("assets")
        .image("player", "player.png")
        .image("enemy", "enemy.png")
        .json("level", "level.json")
        .sound("music", "music.mp3", "bgm");

    // Opción 2: Shortcuts directos
    Assets.image("player", "assets/player.png");
    Assets.json("level", "assets/level.json");
}
```

---

## 4. Grupos de Entidades

### Antes (Gestión Manual)
```haxe
var items:Array<FallingItem> = [];

function spawnItem()
{
    var item = new FallingItem();
    add(item, "entities");
    items.push(item);
}

function update()
{
    // Cleanup manual
    var i = items.length - 1;
    while (i >= 0)
    {
        var item = items[i];
        if (item.destroyed)
        {
            items.splice(i, 1);
        }
        else if (player.collideWith(item))
        {
            remove(item);
            item.destroy();
            items.splice(i, 1);
            score++;
        }
        i--;
    }
}
```

### Ahora (Grupos Automáticos)
```haxe
import glue.display.GEntityGroup;

var items:GEntityGroup<FallingItem>;

override public function init()
{
    items = new GEntityGroup(this, "entities");
}

function spawnItem()
{
    items.add(new FallingItem());
}

function update()
{
    // Cleanup automático
    items.cleanup();

    // Detección de colisión simplificada
    var hit = items.collidesWith(player);
    if (hit != null)
    {
        items.destroy(hit);
        score++;
    }
}
```

**Métodos de GEntityGroup:**
- `add(entity)` - Agregar a grupo y escena
- `remove(entity)` - Remover del grupo
- `destroy(entity)` - Remover y destruir
- `cleanup()` - Limpiar entidades destruidas automáticamente
- `forEach(callback)` - Iterar entidades
- `filter(predicate)` - Filtrar entidades
- `find(predicate)` - Encontrar primera entidad
- `collidesWith(entity)` - Detectar colisión con entidad
- `collidesWithGroup(group, callback)` - Detectar colisiones entre grupos

---

## 5. Input Simplificado

### Antes (Repetitivo)
```haxe
override public function init()
{
    GInput.bindKeys("move_left", [Keyboard.LEFT, Keyboard.A]);
    GInput.bindKeys("move_right", [Keyboard.RIGHT, Keyboard.D]);
    GInput.bindKeys("jump", [Keyboard.SPACE]);
    GInput.bindKeys("shoot", [Keyboard.X]);
}

function update()
{
    var horizontal:Float = 0;
    if (GInput.isKeyPressed("move_left")) horizontal -= 1;
    if (GInput.isKeyPressed("move_right")) horizontal += 1;

    velocity.x = SPEED * horizontal;
}
```

### Ahora (Presets y Helpers)
```haxe
import glue.input.InputActions;

override public function init()
{
    // Opción 1: Preset común
    InputActions.bindWASDAndArrows();

    // Opción 2: Fluent API
    InputActions.create()
        .action("jump", [Keyboard.SPACE])
        .action("shoot", [Keyboard.X])
        .apply();
}

function update()
{
    // Obtener dirección como vector
    var direction = InputActions.getDirection("left", "right", "up", "down");
    velocity = direction * SPEED;

    // O solo eje horizontal
    var horizontal = InputActions.getHorizontal();
    velocity.x = SPEED * horizontal;
}
```

**Presets Disponibles:**
- `InputActions.bindWASD()` - W/A/S/D
- `InputActions.bindArrows()` - Flechas
- `InputActions.bindWASDAndArrows()` - Ambos

**Helpers:**
- `getDirection(left, right, up, down):GVector2D` - Vector direccional
- `getHorizontal(left, right):Float` - Eje horizontal (-1, 0, 1)
- `getVertical(up, down):Float` - Eje vertical (-1, 0, 1)

---

## 6. Utilidades de Escena

### Antes
```haxe
// Buscar entidad manualmente
var target:Enemy = null;
for (entity in entities)
{
    if (Std.isOfType(entity, Enemy))
    {
        var enemy = cast(entity, Enemy);
        if (enemy.isActive)
        {
            target = enemy;
            break;
        }
    }
}
```

### Ahora
```haxe
// Buscar con predicado
var target = find(e -> Std.isOfType(e, Enemy) && cast(e, Enemy).isActive);

// Filtrar entidades
var activeEnemies = filter(e -> Std.isOfType(e, Enemy) && !e.destroyed);

// Iterar todas
forEach(entity -> entity.alpha = 0.5);
```

---

## Ejemplo Completo: Antes vs Ahora

### ANTES

```haxe
package demo.scenes;

import demo.entities.Player;
import demo.entities.FallingItem;
import glue.scene.GScene;
import glue.input.GInput;
import openfl.ui.Keyboard;

class GameScene extends GScene
{
    var player:Player;
    var items:Array<FallingItem> = [];
    var score:Int = 0;

    override public function init()
    {
        addLayer("entities");

        GInput.bindKeys("move_left", [Keyboard.LEFT, Keyboard.A]);
        GInput.bindKeys("move_right", [Keyboard.RIGHT, Keyboard.D]);

        player = new Player();
        player.position.set(400, 500);
        player.anchor.set(0.5, 0.5);
        add(player, "entities");
    }

    override public function preload()
    {
        load.image("player", "assets/player.png");
        load.image("item", "assets/item.png");
        load.sound("collect", "assets/collect.mp3", "sfx");
    }

    function spawnItem()
    {
        var item = new FallingItem();
        item.position.set(Math.random() * 800, -50);
        item.velocity.set(0, 200);
        add(item, "entities");
        items.push(item);
    }

    override public function update()
    {
        var horizontal:Float = 0;
        if (GInput.isKeyPressed("move_left")) horizontal -= 1;
        if (GInput.isKeyPressed("move_right")) horizontal += 1;

        player.velocity.x = 300 * horizontal;

        // Cleanup manual
        var i = items.length - 1;
        while (i >= 0)
        {
            var item = items[i];

            if (item.destroyed)
            {
                items.splice(i, 1);
            }
            else if (player.collideWith(item))
            {
                remove(item);
                item.destroy();
                items.splice(i, 1);
                score++;
            }

            i--;
        }
    }
}
```

### AHORA

```haxe
package demo.scenes;

import demo.entities.Player;
import demo.entities.FallingItem;
import glue.scene.GScene;
import glue.display.GEntityGroup;
import glue.assets.Assets;
import glue.input.InputActions;
import glue.math.GVector2D;

class GameScene extends GScene
{
    var player:Player;
    var items:GEntityGroup<FallingItem>;
    var score:Int = 0;

    override public function init()
    {
        addLayer("entities");

        // Input simplificado
        InputActions.bindWASDAndArrows();

        // Fluent API
        player = add(new Player()
            .at(400, 500)
            .withAnchor(0.5, 0.5), "entities");

        // Grupo de entidades
        items = new GEntityGroup(this, "entities");
    }

    override public function preload()
    {
        // Batch loading
        Assets.batch()
            .fromPath("assets")
            .image("player", "player.png")
            .image("item", "item.png")
            .sound("collect", "collect.mp3", "sfx");
    }

    function spawnItem()
    {
        items.add(new FallingItem()
            .at(Math.random() * 800, -50)
            .withVelocity(0, 200));
    }

    override public function update()
    {
        // Input como vector
        var horizontal = InputActions.getHorizontal();
        player.velocity.x = 300 * horizontal;

        // Cleanup automático
        items.cleanup();

        // Colisión simplificada
        var hit = items.collidesWith(player);
        if (hit != null)
        {
            items.destroy(hit);
            score++;
        }
    }
}
```

---

## Resumen de Mejoras

### ✅ Reducción de Verbosidad

| Aspecto | Antes | Ahora | Reducción |
|---------|-------|-------|-----------|
| Vectores | `position.set(x, y)` | `position = [x, y]` | **50%** |
| Config entidad | 6 líneas | 1 línea encadenada | **83%** |
| Assets batch | Repetitivo | Fluent API | **40%** |
| Gestión grupos | Manual (20+ líneas) | Automático (2 líneas) | **90%** |
| Input setup | 4 líneas | 1 línea preset | **75%** |

### 🚀 Nuevas Capacidades

1. **Conversiones implícitas** - Menos `new` y `.set()`
2. **API Fluida** - Encadenamiento de métodos
3. **Grupos inteligentes** - Gestión automática de colecciones
4. **Presets comunes** - WASD, flechas, etc.
5. **Utilidades funcionales** - `find()`, `filter()`, `forEach()`

### 📦 Nuevos Módulos

- `glue.assets.Assets` - API simplificada de assets
- `glue.display.GEntityGroup` - Grupos de entidades
- `glue.input.InputActions` - Helpers de input
- `glue.math.GConstants` - Constantes (refactor anterior)
- `glue.utils.GSignal` - Sistema de eventos (refactor anterior)

### 🎯 Compatibilidad

**100% Compatible hacia atrás** - Todo el código antiguo sigue funcionando. Las nuevas APIs son **aditivas**, no reemplazan las antiguas.

```haxe
// Ambas formas funcionan:
position.set(100, 200);  // ✅ Vieja forma
position = [100, 200];    // ✅ Nueva forma
```

---

## Filosofía de Diseño

La modernización sigue estos principios:

1. **Menos ruido, más claridad** - Código más legible
2. **API fluida** - Encadenamiento natural
3. **Helpers inteligentes** - Automatización de patrones comunes
4. **Compatibilidad total** - No romper código existente
5. **Zero-cost abstractions** - Inline donde sea posible

---

## Próximos Pasos

1. ✅ Modernización completada
2. 📝 Documenta tus propios patrones
3. 🎮 Empieza a usar las nuevas APIs
4. 💬 Comparte feedback

**El framework está listo para desarrollo moderno!** 🚀
