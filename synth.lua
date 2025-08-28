import pygame
import sys

# Initialize Pygame
pygame.init()

# Set up display
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("FPS and Mouse Position Display")

# Colors
BACKGROUND = (30, 30, 40)
TEXT_COLOR = (220, 220, 220)
PANEL_COLOR = (50, 50, 60)
ACCENT_COLOR = (70, 130, 180)

# Font
font = pygame.font.SysFont("Arial", 24, bold=True)

# Clock for controlling FPS
clock = pygame.time.Clock()

def draw_fps_panel(fps, mouse_pos):
    """Draw a panel at the top center showing FPS and mouse position"""
    # Create text surfaces
    fps_text = font.render(f"FPS: {fps}", True, TEXT_COLOR)
    ms_text = font.render(f"Mouse: {mouse_pos[0]}, {mouse_pos[1]}", True, TEXT_COLOR)
    
    # Calculate panel dimensions
    padding = 20
    panel_width = fps_text.get_width() + ms_text.get_width() + padding * 3
    panel_height = max(fps_text.get_height(), ms_text.get_height()) + padding * 2
    
    # Calculate panel position (top center)
    panel_x = (WIDTH - panel_width) // 2
    panel_y = 10
    
    # Draw panel background with rounded corners
    pygame.draw.rect(screen, PANEL_COLOR, (panel_x, panel_y, panel_width, panel_height), 
                     border_radius=10)
    
    # Draw border
    pygame.draw.rect(screen, ACCENT_COLOR, (panel_x, panel_y, panel_width, panel_height), 
                     width=2, border_radius=10)
    
    # Draw text
    screen.blit(fps_text, (panel_x + padding, panel_y + padding))
    screen.blit(ms_text, (panel_x + fps_text.get_width() + padding * 2, panel_y + padding))

# Main game loop
running = True
while running:
    # Handle events
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                running = False
    
    # Get current mouse position
    mouse_pos = pygame.mouse.get_pos()
    
    # Clear the screen
    screen.fill(BACKGROUND)
    
    # Draw some content to make the display more interesting
    for i in range(10):
        radius = 30 + i * 5
        color = (100 + i * 15, 150, 200 - i * 10)
        pygame.draw.circle(screen, color, mouse_pos, radius, 3)
    
    # Draw FPS and mouse position panel
    current_fps = int(clock.get_fps())
    draw_fps_panel(current_fps, mouse_pos)
    
    # Draw instructions
    instructions = font.render("Move your mouse around. Press ESC to exit.", True, (180, 180, 180))
    screen.blit(instructions, (WIDTH // 2 - instructions.get_width() // 2, HEIGHT - 50))
    
    # Update the display
    pygame.display.flip()
    
    # Control the frame rate
    clock.tick(60)

# Quit Pygame
pygame.quit()
sys.exit()
