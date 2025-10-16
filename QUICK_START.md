# Glue Framework - Quick Start Guide

## 🚀 Inicio Rápido

### Instalación Básica

```bash
# Desde el directorio del proyecto
haxelib dev glue .
```

### Tu Primer Juego (5 minutos)

```haxe
// Main.hx
package;

import glue.Glue;
import GameScene;

class Main extends openfl.display.Sprite
{
    public function new()
    {
        super();
        Glue.run(GameScene, { showStats: true });
    }
}
```

```haxe
// GameScene.hx
package;

import glue.scene.GScene;
import glue.display.GEntity;
import glue.assets.Assets;
import glue.input.InputActions;
import openfl.display.Shape;

class GameScene extends GScene
{
    var player:Player;

    override public function preload()
    {
        // Carga assets (opcional)
        Assets.image("player", "assets/player.png");
    }

    override public function init()
    {
        // Setup de inputs (preset WASD + flechas)
        InputActions.bindWASDAndArrows();

        // Crea y agrega el jugador con API fluida
        player = add(new Player()
            .at(400, 300)
            .withAnchor(0.5, 0.5));
    }

    override public function update()
    {
        // Mueve el jugador con input simplificado
        var direction = InputActions.getDirection();
        player.velocity = direction * 200;
    }
}

class Player extends GEntity
{
    public function new()
    {
        super();

        // Crea un rectángulo simple
        var box = new Shape();
        box.graphics.beginFill(0x3FA9F5);
        box.graphics.drawRect(0, 0, 60, 60);
        box.graphics.endFill();
        _skin.addChild(box);

        width = 60;
        height = 60;
    }
}
```

¡Listo! Ya tienes un jugador que se mueve. 🎮

---

## 📚 Conceptos Principales

### 1. Escenas (GScene)

Las escenas son contenedores de tu juego:

```haxe
class MyScene extends GScene
{
    override public function preload()
    {
        // Carga assets antes de init()
    }

    override public function init()
    {
        // Inicializa tu escena
    }

    override public function update()
    {
        // Lógica del juego (cada frame)
    }
}
```

### 2. Entidades (GEntity)

Todo objeto del juego es una entidad:

```haxe
class Enemy extends GEntity
{
    public function new()
    {
        super();
        // Tu código aquí
    }

    override public function update()
    {
        // Lógica del enemigo
    }
}
```

### 3. Assets

Carga y usa recursos:

```haxe
// En preload()
Assets.image("player", "assets/player.png");
Assets.sound("shoot", "assets/shoot.mp3");

// En cualquier lugar después
var img = Assets.getImage("player");
var snd = Assets.getSound("shoot");
```

### 4. Input

Maneja controles fácilmente:

```haxe
// Setup (una vez)
InputActions.bindWASDAndArrows();

// Uso (en update)
if (InputActions.getHorizontal() > 0)
    moveRight();
```

---

## 🎯 Patrones Comunes

### Crear y Configurar Entidad

```haxe
// ❌ Forma antigua (verbosa)
var enemy = new Enemy();
enemy.position.set(100, 200);
enemy.velocity.set(50, 0);
enemy.scale.set(2, 2);
add(enemy);

// ✅ Forma moderna (fluida)
var enemy = add(new Enemy()
    .at(100, 200)
    .withVelocity(50, 0)
    .withScale(2, 2));
```

### Gestionar Colecciones

```haxe
import glue.display.GEntityGroup;

class GameScene extends GScene
{
    var enemies:GEntityGroup<Enemy>;

    override public function init()
    {
        enemies = new GEntityGroup(this, "enemies");

        // Spawn enemies
        for (i in 0...5)
            enemies.add(new Enemy().at(i * 100, 50));
    }

    override public function update()
    {
        // Auto-cleanup
        enemies.cleanup();

        // Detectar colisión
        var hit = enemies.collidesWith(player);
        if (hit != null)
            enemies.destroy(hit);
    }
}
```

### Cargar Múltiples Assets

```haxe
override public function preload()
{
    Assets.batch()
        .fromPath("assets/sprites")
        .image("player", "player.png")
        .image("enemy", "enemy.png")
        .image("bullet", "bullet.png");

    Assets.batch()
        .fromPath("assets/sounds")
        .sound("shoot", "shoot.mp3", "sfx")
        .sound("music", "music.mp3", "bgm");
}
```

### Vectores Simplificados

```haxe
// Conversión implícita desde array
position = [100, 200];

// Desde objeto
velocity = {x: 50, y: -100};

// Vectores predefinidos
acceleration = GVector2D.down * GRAVITY;
```

---

## 🎮 Ejemplo Completo: Shooter Simple

```haxe
package;

import glue.scene.GScene;
import glue.display.GEntity;
import glue.display.GEntityGroup;
import glue.assets.Assets;
import glue.input.InputActions;
import glue.math.GVector2D;
import glue.utils.GTime;
import openfl.display.Shape;
import openfl.ui.Keyboard;

class ShooterScene extends GScene
{
    var player:Player;
    var enemies:GEntityGroup<Enemy>;
    var bullets:GEntityGroup<Bullet>;
    var shootCooldown:Float = 0;

    override public function init()
    {
        addLayer("entities");

        InputActions.bindWASDAndArrows();
        InputActions.create()
            .action("shoot", [Keyboard.SPACE])
            .apply();

        player = add(new Player()
            .at(400, 550)
            .withAnchor(0.5, 0.5),
            "entities");

        enemies = new GEntityGroup(this, "entities");
        bullets = new GEntityGroup(this, "entities");

        spawnEnemies();
    }

    override public function update()
    {
        // Movimiento del jugador
        var horizontal = InputActions.getHorizontal();
        player.velocity = [horizontal * 300, 0];

        // Disparar
        shootCooldown -= GTime.deltaTime;
        if (GInput.isKeyPressed("shoot") && shootCooldown <= 0)
        {
            shootCooldown = 0.2;
            bullets.add(new Bullet()
                .at(player.position.x, player.position.y - 30)
                .withVelocity(0, -500));
        }

        // Cleanup
        enemies.cleanup();
        bullets.cleanup();

        // Colisiones
        bullets.collidesWithGroup(enemies, (bullet, enemy) -> {
            bullets.destroy(bullet);
            enemies.destroy(enemy);
        });

        // Game Over
        var hit = enemies.collidesWith(player);
        if (hit != null)
            trace("GAME OVER!");
    }

    function spawnEnemies()
    {
        for (i in 0...10)
        {
            enemies.add(new Enemy()
                .at(50 + i * 70, 50)
                .withVelocity(100, 0));
        }
    }
}

class Player extends GEntity
{
    public function new()
    {
        super();
        var box = new Shape();
        box.graphics.beginFill(0x00FF00);
        box.graphics.drawRect(0, 0, 40, 40);
        box.graphics.endFill();
        _skin.addChild(box);
        width = height = 40;
    }
}

class Enemy extends GEntity
{
    public function new()
    {
        super();
        var box = new Shape();
        box.graphics.beginFill(0xFF0000);
        box.graphics.drawRect(0, 0, 30, 30);
        box.graphics.endFill();
        _skin.addChild(box);
        width = height = 30;
        bounds.setTo(-15, -15, 30, 30);
    }

    override public function update()
    {
        // Rebote en bordes
        if (position.x < 0 || position.x > Glue.width)
            velocity.x *= -1;
    }
}

class Bullet extends GEntity
{
    public function new()
    {
        super();
        var circle = new Shape();
        circle.graphics.beginFill(0xFFFF00);
        circle.graphics.drawCircle(5, 5, 5);
        circle.graphics.endFill();
        _skin.addChild(circle);
        width = height = 10;
        bounds.setTo(-5, -5, 10, 10);
    }

    override public function update()
    {
        if (position.y < -20)
            destroy();
    }
}
```

---

## 📖 Documentación Completa

- **`MODERN_ARCHITECTURE.md`** - Guía detallada de todas las features
- **`ARCHITECTURE_SUMMARY.md`** - Resumen técnico de cambios
- **`REFACTORING_SUMMARY.md`** - Historial de refactoring

---

## 🎨 Tips y Trucos

### 1. Encadena Todo lo que Puedas

```haxe
// Aprovecha la API fluida
add(new Boss()
    .at(centerX, 100)
    .withVelocity(0, 20)
    .withScale(2, 2)
    .withAnchor(0.5, 0.5)
    .withAlpha(0.8));
```

### 2. Usa Grupos Para Todo

```haxe
var powerups:GEntityGroup<Powerup>;
var particles:GEntityGroup<Particle>;

// Cleanup automático en un solo lugar
powerups.cleanup();
particles.cleanup();
```

### 3. Presets de Input

```haxe
// No reinventes la rueda
InputActions.bindWASDAndArrows();
```

### 4. Batch Loading

```haxe
// Más organizado con fromPath
Assets.batch()
    .fromPath("assets/level1")
    .image("bg", "background.png")
    .image("tiles", "tileset.png")
    .json("map", "map.json");
```

### 5. Vectores Predefinidos

```haxe
// Claros y concisos
gravity = GVector2D.down * 9.8;
spawn = GVector2D.zero;
```

---

## ⚡ Performance Tips

1. **Usa entity groups** - Más eficiente que arrays manuales
2. **Inline todo** - Las APIs modernas usan `inline` extensivamente
3. **Cleanup regular** - `group.cleanup()` en tu update loop
4. **Reutiliza objetos** - Object pooling para bullets/particles
5. **Bounds apropiados** - Define bounds precisos para colisiones

---

## 🐛 Debugging

```haxe
// Mostrar stats de performance
Glue.run(MyScene, { showStats: true });

// Mostrar bounds de entidades
Glue.showBounds = true;

// Log de escenas
Glue.isDebug = true;
```

---

## 🎓 Siguiente Paso

1. **Crea tu primer juego** con este quick start
2. **Lee** `MODERN_ARCHITECTURE.md` para features avanzadas
3. **Mira** `ModernDemoScene.hx` como ejemplo real
4. **Experimenta** con las nuevas APIs

**¡Diviértete creando juegos!** 🚀🎮
