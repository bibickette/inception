RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
CYAN = \033[0;36m
RESET = \033[0m
# $(GREEN)
# $(RED)
# $(BLUE)
# $(PURPLE)
# $(CYAN)
# $(YELLOW)
# $(RESET)

all: first

first: list
	@if [ -d /home/phwang/data/wordpress ] && [ -d /home/phwang/data/mariadb ]; then \
		echo "$(GREEN)Les dossiers existent déjà, pas de creation$(RESET)"; \
		echo "$(YELLOW)You can start make run$(RESET)"; \
	else \
		echo "$(GREEN)----- Dir list de home :$(RESET)"; \
		ls /home/phwang; \
		echo ""; \
		echo "$(GREEN)----- Creation des dossiers accueillant les volumes$(RESET)"; \
		mkdir -p /home/phwang/data/wordpress; \
		mkdir -p /home/phwang/data/mariadb; \
		echo "$(BLUE)----- Tree de data :$(RESET)"; \
		tree /home/phwang/data; \
		echo ""; \
		echo "$(GREEN)----- Dir list de home :$(RESET)"; \
		ls /home/phwang; \
		echo ""; \
		echo "$(YELLOW)You can start make run$(RESET)"; \
	fi

run: list
	@echo "$(GREEN)----- LANCEMENT DE DOCKER COMPOSE :$(RESET)"
	docker-compose -f srcs/docker-compose.yml up --build

list:
	@echo "$(GREEN)----- List des containers en cours :$(RESET)"
	@docker ps 
	@echo ""

	@echo "$(GREEN)----- List des images :$(RESET)"
	@docker images 
	@echo ""

	@echo "$(GREEN)----- List des volumes :$(RESET)"
	@docker volume ls
	@echo ""

	@echo "$(GREEN)----- List des networks :$(RESET)"
	@docker network ls
	@echo ""


clean:
	@echo "$(GREEN)----- List des containers en cours :$(RESET)"
	docker stop $$(docker ps -aq)
	@echo "$(RED)----- Docker stop done -----$(RESET)"
	@echo ""


containers_clean:
	@echo "$(GREEN)----- List des containers :$(RESET)"
	docker rm $$(docker ps -aq)
	@echo "$(YELLOW)----- List des containers apres rm all :$(RESET)"
	@docker ps -aq
	@echo ""


images_clean:
	@echo "$(GREEN)----- List des images :$(RESET)"
	@docker images -q
	docker rmi $$(docker images -q)
	@echo "$(YELLOW)----- List des images apres rmi all :$(RESET)"
	@docker images -q
	@echo ""


volumes_clean:
	@echo "$(GREEN)List des volumes:$(RESET)"
	@docker volume ls
	docker volume rm $$(docker volume ls -q)
	@echo "$(YELLOW)List des volumes apres rm all:$(RESET)"
	@docker volume ls
	@echo ""

networks_clean:
	@echo "$(GREEN)----- List des network :$(RESET)"
	docker network ls
	@echo "$(BLUE)Deleting srcs_inception...$(RESET)"
	@docker network rm srcs_inception
	@echo "$(YELLOW)----- List des network apres rm all :$(RESET)"
	@docker network ls
	@echo ""

fclean: clean containers_clean images_clean volumes_clean networks_clean list
	@echo "$(PURPLE)----- Docker system prune de verification !$(RESET)"
	docker system prune -a
	@echo "$(BLUE)----- Delete les dossiers crees pour les volumes$(RESET)"
	sudo rm -rf /home/phwang/data
	@echo "$(GREEN)----- Dir list de home :$(RESET)"
	ls /home/phwang

re: fclean first

.PHONY: all fclean clean re run containers_clean images_clean volumes_clean networks_clean list