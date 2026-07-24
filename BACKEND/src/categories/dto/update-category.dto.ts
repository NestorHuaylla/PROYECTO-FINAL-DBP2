import { PartialType } from '@nestjs/mapped-types';
import { CreateCategoryDto } from './create-category.dto';

// PartialType hace que todos los campos de CreateCategoryDto sean
// opcionales aquí, ya que en un update no siempre se mandan todos.
export class UpdateCategoryDto extends PartialType(CreateCategoryDto) {}
